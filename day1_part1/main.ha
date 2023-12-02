use fmt;
use os;
use io;
use strings;
use strconv;

export fn main() void = {
    const input = os::open("input.txt")!;
    defer io::close(input)!;

    const input = io::drain(input)!;
    defer free(input);

    const input = strings::fromutf8(input)!;
    const input = strings::split(input, "\n");
    defer free(input);

    let sum: int = 0;

    for (let i = 0z; i < len(input); i += 1) {
        const line = input[i];
        let firstDigit: (str | void) = void, lastDigit: (str | void) = void;
        for (let j = 0z; j < len(line); j += 1) {
            const currentChar = strings::sub(line, j, j + 1);
            match (strconv::stoi(currentChar)) {
            case int =>
                yield void;
            case strconv::error =>
                continue;
            };

            match (firstDigit) {
            case void =>
                firstDigit = currentChar;
                lastDigit = currentChar;
                continue;
            case str =>
                lastDigit = currentChar;
            };
        };

        if (firstDigit is str && lastDigit is str) {
            const calibStrVal = strings::concat(firstDigit as str, lastDigit as str);
            defer free(calibStrVal);

            const calibNumVal = strconv::stoi(calibStrVal)!;
            sum += calibNumVal;
        };
    };

    fmt::printfln("Day 1 Part 1 {}", sum)!;
};
