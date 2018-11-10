export const mapMany = <T>(count: number, func: (index: number) => T) => Array.from(Array(count).keys()).map(func)

export const padNum = (num: number, size: number, padChar: string) => {
    var s = String(num);
    while (s.length < (size || 2)) {s = padChar + s;}
    return s;
}
