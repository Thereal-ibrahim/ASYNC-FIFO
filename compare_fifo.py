from pathlib import Path
import sys


def read_values(path: Path) -> list[str]:
    return [line.strip().lower() for line in path.read_text().splitlines()]


def main() -> int:
    write_path = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("Wr_Data.txt")
    read_path = Path(sys.argv[2]) if len(sys.argv) > 2 else Path("Rd_Data.txt")

    write_values = read_values(write_path)
    read_values_list = read_values(read_path)
    differences = 0

    for line_number, (write_value, read_value) in enumerate(
        zip(write_values, read_values_list), start=1
    ):
        if write_value != read_value:
            differences += 1
            print(
                f"Line {line_number}: "
                f"Wr_Data={write_value!r}, Rd_Data={read_value!r}"
            )

    common_lines = min(len(write_values), len(read_values_list))

    if len(write_values) > common_lines:
        differences += len(write_values) - common_lines
        for line_number in range(common_lines + 1, len(write_values) + 1):
            print(f"Line {line_number}: Wr_Data={write_values[line_number - 1]!r}, Rd_Data=<missing>")

    if len(read_values_list) > common_lines:
        differences += len(read_values_list) - common_lines
        for line_number in range(common_lines + 1, len(read_values_list) + 1):
            print(f"Line {line_number}: Wr_Data=<missing>, Rd_Data={read_values_list[line_number - 1]!r}")

    if differences == 0:
        print(f"Match: {common_lines} lines compared.")
        return 0

    print(f"Found {differences} difference(s).")
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
