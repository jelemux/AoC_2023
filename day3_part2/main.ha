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
        const line = strings::toutf8(line);

        // skip empty lines (e.g., last line)
        if (len(line) == 0) {
            continue;
        };

        for (let j = 0z; j < len(line); j += 1) {
            let currentChar = line[j];
            switch (currentChar) {
            case '*' =>
                let leadingNum: (int | void) = void;
                let leadingPrevNum: (int | void) = void;
                let leadingNextNum: (int | void) = void;
                let centralPrevNum: (int | void) = void;
                let centralNextNum: (int | void) = void;
                let followingNum: (int | void) = void;
                let followingPrevNum: (int | void) = void;
                let followingNextNum: (int | void) = void;

                if (j > 0) {
                    leadingNum = parseNum(line, j-1);
                    if (i > 0) {
                        leadingPrevNum = parseNum(strings::toutf8(input[i-1]), j-1);
                    };
                    if (i < len(input)) {
                        leadingNextNum = parseNum(strings::toutf8(input[i+1]), j-1);
                    };
                };

                if (i > 0) {
                    centralPrevNum = parseNum(strings::toutf8(input[i-1]), j);
                };
                if (i < len(input)) {
                    centralNextNum = parseNum(strings::toutf8(input[i+1]), j);
                };

                if (j < len(line)) {
                    followingNum = parseNum(line, j+1);
                    if (i > 0) {
                        followingPrevNum = parseNum(strings::toutf8(input[i-1]), j+1);
                    };
                    if (i < len(input)) {
                        followingNextNum = parseNum(strings::toutf8(input[i+1]), j+1);
                    };
                };

                let adjacentNums: []int = [];
                defer free(adjacentNums);

                appendNum(&adjacentNums, leadingNum);
                appendNum(&adjacentNums, followingNum);
                if (centralPrevNum is void) {
                    appendNum(&adjacentNums, leadingPrevNum);
                    appendNum(&adjacentNums, followingPrevNum);
                } else {
                    appendNum(&adjacentNums, centralPrevNum);
                };
                if (centralNextNum is void) {
                    appendNum(&adjacentNums, leadingNextNum);
                    appendNum(&adjacentNums, followingNextNum);
                } else {
                    appendNum(&adjacentNums, centralNextNum);
                };

                if (len(adjacentNums) == 2) {
                    sum += adjacentNums[0] * adjacentNums[1];
                };
            case =>
                continue;
            };
        };
    };

    fmt::printfln("Day 3 Part 2: {}", sum)!;
};

fn appendNum(nums: *[]int, toAppend: (int | void)) void = {
    match (toAppend) {
    case let num: int =>
        append(nums, num);
    case =>
        yield;
    };
};

fn parseNum(line: []u8, idx: size) (int | void) = {
    if (isDigit(line[idx])) {
        let startIdx = idx;
        for (startIdx > 0 && isDigit(line[startIdx - 1])) {
            startIdx -= 1;
        };

        let endIdx = idx;
        for (endIdx < len(line) && isDigit(line[endIdx])) {
            endIdx += 1;
        };

        const line = strings::fromutf8_unsafe(line);
        const numStr = strings::sub(line, startIdx, endIdx);
        return strconv::stoi(numStr)!;
    };

    return void;
};

fn isDigit(utf8Char: u8) bool = {
    return utf8Char >= '0' && utf8Char <= '9';
};