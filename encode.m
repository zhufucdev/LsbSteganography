function encoded = encode(encodingText, imBuffer)
    ENCODING_CAP = 256; RESERVED_PARTITION_CAP = 1;
    textCap = size(encodingText, 2);
    encoded = imBuffer;
    if textCap > (ENCODING_CAP - RESERVED_PARTITION_CAP) / 8
        fprintf('Too much information to encode. I will fail.');
        return;
    end

    h = size(imBuffer, 1);
    w = size(imBuffer, 2);

    bufferCap = h * w;
    gridSizeUnhinged = sqrt(bufferCap / ENCODING_CAP);
    gridH = ceil(h / gridSizeUnhinged);
    gridW = ceil(w / gridSizeUnhinged);
    blockH = floor(h / gridH);
    blockW = floor(w / gridW);
    if min(blockW, blockH) <= 2
        fprintf('Small block size (%d) might be ineffective in robustness. Try to encode in a bigger image.', min(blockW, blockH));
    end

    posBlocked = mapHorizontalVertical(h / w * 10, [gridH, gridW], ENCODING_CAP);
    function embedded = embeddedInLsb(pixel, bit)
        embedded = bitset(pixel, 1, bit);
    end

    function bit = encodingBit(pos)
        y_ = ceil(pos / 8);
        if y_ > textCap
            bit = 0;
        else
            bit = bitget(uint8(encodingText(y_)), rem(pos - 1, 8) + 1);
        end
    end

    for y = 1:gridH
        for x = 1:gridW
            py = (posBlocked(y, x, 1) - 1) * blockH + 1;
            px = (posBlocked(y, x, 2) - 1) * blockW + 1;
            if py <= 0 || px <= 0
                return;
            end

            bit = encodingBit((y - 1) * gridW + x);
            embedding = embeddedInLsb(imBuffer(py:py + blockH - 1, px:px + blockW - 1), bit);
            encoded(py:py + blockH - 1, px:px + blockW - 1) = embedding;
        end
    end
end
