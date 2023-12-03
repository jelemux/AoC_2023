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
        const lineChars = strings::toutf8(line);

        // quit on empty line (last line)
        if (line == "") {
            break;
        };

        let startIdx: (size | void) = void;
        for (let j = 0z; j < len(lineChars); j += 1) {
            let currentChar = lineChars[j];
            switch (currentChar) {
            case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' =>
                match (startIdx) {
                case size =>
                    continue;
                case void =>
                    startIdx = j;
                };
            case =>
                match (startIdx) {
                case void =>
                    continue;
                case let start: size =>
                    if (isPartNum(input, i, start, j)) {
                        sum += parseNum(line, start, j);
                    };
                    startIdx = void;
                };
            };
        };

        match (startIdx) {
        case void =>
            continue;
        case let start: size =>
            if (isPartNum(input, i, start, len(line))) {
                sum += parseNum(line, start, len(line));
            };
        };
    };

    fmt::printfln("Day 3 Part 1: {}", sum)!;
};

fn isPartNum(input: []str, lineNum: size, startIdx: size, endIdx: size) bool = {
    const currentLineChars = strings::toutf8(input[lineNum]);

    // check before
    if (startIdx > 0 && isSymbol(currentLineChars[startIdx-1])) {
        return true;
    };
    // check after
    if (endIdx < len(currentLineChars) && isSymbol(currentLineChars[endIdx])) {
        return true;
    };

    const lineLen = len(currentLineChars);
    const inFrontIdx = if (startIdx <= 0) 0z else startIdx - 1;
    const backIdx = if (endIdx >= lineLen) lineLen - 1 else endIdx;

    // check prev line
    if (lineNum > 0) {
        const prevLineChars = strings::toutf8(input[lineNum - 1]);
        for (let i = inFrontIdx; i <= backIdx; i += 1) {
            if (isSymbol(prevLineChars[i])) {
                return true;
            };
        };
    };
    // check next line
    if (lineNum < len(input) - 1) {
        const nextLineChars = strings::toutf8(input[lineNum + 1]);
        if (len(nextLineChars) == 0) {
            return false;
        };
        for (let i = inFrontIdx; i <= backIdx; i += 1) {
            if (isSymbol(nextLineChars[i])) {
                return true;
            };
        };
    };

    return false;
};

fn isSymbol(c: u8) bool = {
    switch (c) {
    case '*', '&', '$', '-', '/', '#', '=', '%', '@', '+' =>
        return true;
    case =>
        return false;
    };
};

fn parseNum(line: str, startIdx: size, endIdx: size) int = {
    const numStr = strings::sub(line, startIdx, endIdx);
    return strconv::stoi(numStr)!;
};