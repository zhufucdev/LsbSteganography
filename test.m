im = imread('test.jpeg');
e = encode('IAmABear', im);
er = imresize(e, 0.8);

decode(er)