function decoded = decode(imBuffer)
    ENCODING_CAP = 256;

    h = size(imBuffer, 1);
    w = size(imBuffer, 2);

    bufferCap = h * w;
    gridSizeUnhinged = sqrt(bufferCap / ENCODING_CAP);
    gridH = ceil(h / gridSizeUnhinged);
    gridW = ceil(w / gridSizeUnhinged);
    blockH = floor(h / gridH);
    blockW = floor(w / gridW);

    posBlocked = mapHorizontalVertical(h / w * 10, [gridH gridW], ENCODING_CAP);
    function embedding = embeddingInLsp(pixel)
        embedding = bitget(pixel, 1);
    end

    function block = readBlock(y, x)
        py = (posBlocked(y, x, 1) - 1) * blockH + 1;
        px = (posBlocked(y, x, 2) - 1) * blockW + 1;
        if py <= 0 || px <= 0
            block = -1;
        else
            b = embeddingInLsp(imBuffer(py:py + blockH - 1, px:px + blockW - 1));
            block = mode(b, 'all');
        end
    end

    decodingBuff = 0;
    decodingPos = 1;
    decoded = '';
    inverted = false;

    if readBlock(ceil(ENCODING_CAP / gridW), rem(ENCODING_CAP, gridW)) == 1
        inverted = true;
    end

    for y = 1:gridH
        for x = 1:gridW
            block = readBlock(y, x);
            if block == -1
                return;
            end

            if inverted
                block = not(block);
            end

            decodingBuff = bitset(decodingBuff, decodingPos, block);
            decodingPos = decodingPos + 1;
            if decodingPos > 8
                decoded = strcat(decoded, char(decodingBuff));
                decodingBuff = 0;
                decodingPos = 1;
            end
        end
    end
end
