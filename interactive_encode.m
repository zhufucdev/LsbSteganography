text = input('Text to encode:', 's');
file = input('Path to encoding image:', 's');

im = imread(file);
encodeBuffer = encode(text, im);

dest = input('Path to output file (encoded.png):', 's');
if size(dest, 2) <= 0
    dest = 'encoded.png';
end

imwrite(encodeBuffer, dest);