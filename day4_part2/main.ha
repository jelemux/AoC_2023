use fmt;
use os;
use io;
use strings;
use strconv;
use math;

let lookupTable: []size = [];

@fini fn fini() void = {
    free(lookupTable);
};

fn lookup(idx: size) (size | void) = {
    if (idx < len(lookupTable)) {
        return lookupTable[idx];
    };
    return void;
};

fn put(idx: size, value: size) void = {
    if (len(lookupTable) > 0 && idx < len(lookupTable) - 1) {
        fmt::fatalf("cannot insert in lookuptable");
    };

    insert(lookupTable[idx], value);
};

export fn main() void = {
    const input = os::open("input.txt")!;
    defer io::close(input)!;

    const input = io::drain(input)!;
    defer free(input);

    const input = strings::fromutf8(input)!;
    const input = strings::split(input, "\n");
    defer free(input);

    let sum = countScratchCards(input, 0z, 0z);

    fmt::printfln("Day 4 Part 2: {}", sum)!;
};

fn countScratchCards(input: []str, currentIdx: size, currentSum: size) size = {
    currentSum += 1;
    const nextNLines = countWinningNums(input[currentIdx]);

    fmt::printfln("Card {}; current sum: {}; winning nums: {}", currentIdx+1, currentSum, nextNLines)!;

    for (let i = currentIdx + 1; i < len(input) && i <= currentIdx + nextNLines + 1; i += 1) {
        currentSum = countScratchCards(input, i, currentSum);
    };
    return currentSum;
};

fn countWinningNums(line: str) size = {
    // skip empty lines (e.g., last line)
    if (len(line) == 0) {
        return 0;
    };

    const declAndCard = strings::split(line, ": ");
    defer free(declAndCard);

    const cardNumber = declAndCard[0];
    const cardNumber = strings::split(cardNumber, " ");
    defer free(cardNumber);
    const cardNumber = cardNumber[len(cardNumber)-1];
    const cardNumber = strconv::stoz(cardNumber)!;

    match (lookup(cardNumber-1)) {
    case let count: size =>
        return count;
    case =>
        yield;
    };

    const numbers = strings::split(declAndCard[1], " | ");
    defer free(numbers);

    const myNumbers = strings::split(numbers[0], " ");
    defer free(myNumbers);
    const winningNumbers = strings::split(numbers[1], " ");
    defer free(winningNumbers);

    let winningNumbersCount = 0z;

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

    put(cardNumber-1, winningNumbersCount);
    return winningNumbersCount;
};