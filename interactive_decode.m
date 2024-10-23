file = input('Path to decoding image:', 's');

im = imread(file);
decodeBuffer = decode(im);

fprintf("%s", decodeBuffer);