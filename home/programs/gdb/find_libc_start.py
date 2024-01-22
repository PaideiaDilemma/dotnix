import gdb
import re


def escape_ansi(content: bytes) -> bytes:
    """
    This function strips all ansi escape sequences from `content`.

    I took the regex from this post: https://stackoverflow.com/a/14693789
    THis matches 7-bit C1 ANSI sequences but not 8-bit ones!!
    """
    ansi_re = re.compile(
        rb"""
        \x1B  # ESC
        (?:   # 7-bit C1 Fe (except CSI)
            [@-Z\\-_]
        |     # or [ for CSI, followed by a control sequence
            \[
            [0-?]*  # Parameter bytes
            [ -/]*  # Intermediate bytes
            [@-~]   # Final byte
        )
    """,
        re.VERBOSE,
    )
    return ansi_re.sub(b"", content)


class libc_start(gdb.Command):
    def __init__(self):
        super(libc_start, self).__init__("libc-start", gdb.COMMAND_USER)

    def invoke(self, tty, from_tty: bool):
        libc_map = gdb.execute("vmmap libc.so", to_string=True)
        libc_map = escape_ansi(libc_map.encode("utf-8")).decode()
        for line in libc_map.split("\n"):
            line = line.strip("\t ►")
            if line.startswith("0x"):
                start = int(line.split(" ")[0], 16)
                print(hex(start))
                return

        raise gdb.GdbError("libc not found")


class set_arena(gdb.Command):
    def __init__(self):
        super(set_arena, self).__init__("set-arena", gdb.COMMAND_USER)

        try:
            _ = gdb.execute("help gef", to_string=True)
        except gdb.error:
            self.is_gef = False
        else:
            self.is_gef = True
            return

        try:
            _ = gdb.execute("help pwndbg", to_string=True)
        except gdb.error:
            self.is_pwndbg = False
        else:
            self.is_pwndbg = True
            return

    def invoke(self, offset, from_tty: bool):
        if not offset:
            raise gdb.GdbError("offset must be specified")

        if not offset.startswith("0x"):
            raise gdb.GdbError("offset must be hex")

        libc_start = gdb.execute("libc-start", to_string=True)
        libc_start = int(libc_start, 16)

        offset = int(offset, 16)

        arena = libc_start + offset

        if self.is_gef:
            gdb.execute(f"heap set-arena {hex(arena)}")

        elif self.is_pwndbg:
            gdb.execute(f"set main-arena {hex(arena)}")
            gdb.execute(f"set glibc 2.38")


libc_start()
set_arena()
