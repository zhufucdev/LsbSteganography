text = input('Text to encode:', 's');
file = input('Path to encoding image:', 's');

im = imread(file);
encode_buffer = encode(text, im);

subplot(1, 2, 1);
imshow(im);

subplot(1, 2, 2);
imshow(encode_buffer);
