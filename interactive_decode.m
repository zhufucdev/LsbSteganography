text = input('Text to decode:', 's');
file = input('Path to decoding image:', 's');

im = imread(file);
decodeBuffer = decode(text, im);

subplot(1, 2, 1);
imshow(im);

subplot(1, 2, 2);
imshow(decodeBuffer);
