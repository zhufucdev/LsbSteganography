function encoding = encode(encodingText, imBuffer)
    ENCODING_CAP = 256; RESERVED_PARTITION_CAP = 1; MAX_BLOCKSIZE = 4;
    textCap = size(encodingText, 2);
    encoding = imBuffer;
    if textCap > (ENCODING_CAP - RESERVED_PARTITION_CAP) / 8
        fprintf('Too much information to encode. I will fail.');
        return;
    end

    h = size(imBuffer, 1);
    w = size(imBuffer, 2);

    bufferCap = h * w;
    blockSizeUnhinged = sqrt(bufferCap / ENCODING_CAP);
    blockSize = min([int32(blockSizeUnhinged) MAX_BLOCKSIZE]);
    if blockSize <= 2
        fprintf('Small block size (%d) might be ineffective in robustness. Try to encode in a bigger image.', blockSize);
    end
    blockH = ceil(h / blockSizeUnhinged);
    blockW = ceil(w / blockSizeUnhinged);

    posBlocked = mapHorizontalVertical(h / w * 100000, [blockH blockW], ENCODING_CAP);
    function embedded = embeddedAtLsb(pixel, bit)
        embedded = bitor(bitand(pixel, 0xFE), bit);
    end

    function bit = encodingBit(pos)
        y_ = floor(pos / 8);
        if y_ > textCap
            bit = 0;
        else
            bit = bitget(uint8(encodingText(y_)), rem(pos, 8));
        end
    end

    for y = 1:blockH
        for x = 1:blockW
            py = posBlocked(y, x, 1);
            px = posBlocked(y, x, 2);
            if py == 0 || px == 0
                return;
            end

            encoding(py, px) = embeddedAtLsb(imBuffer(py, px), encodingBit((y - 1) * blockH + blockW));
        end
    end
end
