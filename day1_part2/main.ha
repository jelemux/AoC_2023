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

    const numbers: [9]str = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];

    let sum: int = 0;

    for (let i = 0z; i < len(input); i += 1) {
        const line = input[i];
        let firstDigit: (str | void) = void, lastDigit: (str | void) = void;
        let firstDigitIdx: (size | void) = void, lastDigitIdx: (size | void) = void;
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
                firstDigitIdx = j;
                lastDigit = currentChar;
                lastDigitIdx = j;
                continue;
            case str =>
                lastDigit = currentChar;
                lastDigitIdx = j;
            };
        };

        if (firstDigit is str && lastDigit is str && firstDigitIdx is size && lastDigitIdx is size) {
            for (let k = 0z; k < len(numbers); k += 1) {
                const numberStr = numbers[k];
                match (strings::byteindex(line, numberStr)) {
                case let idx: size =>
                    if (idx < (firstDigitIdx as size)) {
                        firstDigit = strings::dup(strconv::ztos(k + 1));
                        firstDigitIdx = idx;
                    };
                case void =>
                    yield void;
                };
                match (strings::rbyteindex(line, numberStr)) {
                case let idx: size =>
                    if (idx > (lastDigitIdx as size)) {
                        lastDigit = strings::dup(strconv::ztos(k + 1));
                        lastDigitIdx = idx;
                    };
                case void =>
                    yield void;
                };
            };

            const calibStrVal = strings::concat(firstDigit as str, lastDigit as str);
            defer free(calibStrVal);

            const calibNumVal = strconv::stoi(calibStrVal)!;
            sum += calibNumVal;
        };
    };

    fmt::printfln("Day 1 Part 2 {}", sum)!;
};