function decoded = decode(imBuffer)
    ENCODING_CAP = 256; MAX_BLOCKSIZE = 4;

    h = size(imBuffer, 1);
    w = size(imBuffer, 2);

    bufferCap = h * w;
    blockSizeUnhinged = sqrt(bufferCap / ENCODING_CAP);
    blockSize = min([int32(blockSizeUnhinged) MAX_BLOCKSIZE]);
    blockH = ceil(h / blockSizeUnhinged);
    blockW = ceil(w / blockSizeUnhinged);

    posBlocked = mapHorizontalVertical(h / w * 100000, [blockH blockW], ENCODING_CAP);
    function embedding = embeddingInLsp(pixel)
        embedding = bitget(pixel, 1);
    end

    decodingBuff = 0;
    decodingPos = 1;
    decoded = '';

    for y = 1:blockH
        for x = 1:blockW
            py = posBlocked(y, x, 1) * blockSize;
            px = posBlocked(y, x, 2) * blockSize;
            if py == 0 || px == 0
                return;
            end

            block = embeddingInLsp(imBuffer(py:py + blockSize - 1, px:px + blockSize - 1));
            bit = mode(block, 'all');
            decodingBuff = bitor(decodingBuff, bitset(0, decodingPos, bit));
            decodingPos = decodingPos + 1;
            if decodingPos > 8
                decoded = strcat(decoded, char(decodingBuff));
                decodingBuff = 0;
                decodingPos = 1;
            end
        end
    end
end
