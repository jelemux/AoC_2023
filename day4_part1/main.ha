use fmt;
use os;
use io;
use strings;
use strconv;
use math;

export fn main() void = {
    const input = os::open("input.txt")!;
    defer io::close(input)!;

    const input = io::drain(input)!;
    defer free(input);

    const input = strings::fromutf8(input)!;
    const input = strings::split(input, "\n");
    defer free(input);

    let sum = 0u;

    for (let i = 0z; i < len(input); i += 1) {
        const line = input[i];

        // skip empty lines (e.g., last line)
        if (len(line) == 0) {
            continue;
        };

        // count winning numbers
        const declAndCard = strings::split(line, ": ");
        defer free(declAndCard);

        const numbers = strings::split(declAndCard[1], " | ");
        defer free(numbers);

        const myNumbers = strings::split(numbers[0], " ");
        defer free(myNumbers);
        const winningNumbers = strings::split(numbers[1], " ");
        defer free(winningNumbers);

        let winningNumbersCount = 0u;

        for (let i = 0z; i < len(myNumbers); i += 1) {
            const myCurrentNum = myNumbers[i];
            if (len(myCurrentNum) == 0) {
                // sometimes there are two spaces, so by splitting we get an empty string
                // we'll have to filter that
                continue;
            };

            for (let j = 0z; j < len(winningNumbers); j += 1) {
                const currentWinningNum = winningNumbers[j];
                if (len(currentWinningNum) == 0) {
                    // sometimes there are two spaces, so by splitting we get an empty string
                    // we'll have to filter that
                    continue;
                };

                if (myCurrentNum == currentWinningNum) {
                    winningNumbersCount += 1;
                };
            };
        };

        if (winningNumbersCount > 0) {
            sum += math::powf64(2: f64, (winningNumbersCount - 1): f64): uint;
        };
    };

    fmt::printfln("Day 4 Part 1: {}", sum)!;
};