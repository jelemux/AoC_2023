use fmt;
use os;
use io;
use strings;
use strconv;

type game = struct {
    num: int,
    draws: []draw,
};

type draw = struct {
    red: int,
    green: int,
    blue: int,
};

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
        if (line == "") {
            break;
        };

        const game = parseGame(line);
        defer free(game.draws);

        if (gamePossible(game)) {
            sum += game.num;
        };
    };

    fmt::printfln("Day 2 Part 1: {}", sum)!;
};

fn gamePossible(game: game) bool = {
    for (let i = 0z; i < len(game.draws); i += 1) {
        if (!drawPossible(game.draws[i])) {
            return false;
        };
    };

    return true;
};

fn drawPossible(draw: draw) bool = {
    if (draw.red > 12) {
        return false;
    };
    if (draw.green > 13) {
        return false;
    };
    if (draw.blue > 14) {
        return false;
    };

    return true;
};

fn parseGame(line: str) game = {
    const gameParts = strings::split(line, ": ");

    const gameNum = parseGameNum(gameParts[0]);
    const draws = parseDraws(gameParts[1]);

    return game{num = gameNum, draws = draws};
};

fn parseGameNum(gameDecl: str) int = {
    const gameNumStr = strings::sub(gameDecl, 5, len(gameDecl));
    return strconv::stoi(gameNumStr)!;
};

fn parseDraws(gameBody: str) []draw = {
    const drawStrs = strings::split(gameBody, "; ");
    defer free(drawStrs);

    const draws = alloc([draw{red = 0, green = 0, blue = 0}...], len(drawStrs));
    for (let i = 0z; i < len(drawStrs); i += 1) {
        draws[i] = parseDraw(drawStrs[i]);
    };

    return draws;
};

fn parseDraw(drawStr: str) draw = {
    const colorStrs = strings::split(drawStr, ", ");
    defer free(colorStrs);

    let draw = draw{red = 0, green = 0, blue = 0};
    for (let i = 0z; i < len(colorStrs); i += 1) {
        let colorCount = parseColorCount(colorStrs[i]);
        switch (colorCount.color) {
            case color::RED =>
                draw.red = colorCount.count;
            case color::GREEN =>
                draw.green = colorCount.count;
            case color::BLUE =>
                draw.blue = colorCount.count;
        };
    };

    return draw;
};

type color = enum {
    RED,
    GREEN,
    BLUE,
};

type colorCount = struct {
    color: color,
    count: int,
};

fn parseColorCount(colorStr: str) colorCount = {
    const components = strings::split(colorStr, " ");
    defer free(components);

    const count = strconv::stoi(components[0])!;
    const color = switch (components[1]) {
    case "red" =>
        yield color::RED;
    case "green" =>
        yield color::GREEN;
    case "blue" =>
        yield color::BLUE;
    case =>
        fmt::fatalf("unknown color: {}", components[1]);
    };

    return colorCount{color = color, count = count};
};