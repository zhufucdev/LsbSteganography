function map = mapHorizontalVertical(seed, size_, count_limit)
    function p = gen_()
        p = [randi(size_(1)), randi(size_(2))];
    end

    rng(seed, 'twister');
    count = 0;
    map = zeros(size_(1), size_(2), 2);
    for y = 1:size_(1)
        if count >= count_limit
            break;
        end

        for x = 1:size_(2)
            if count >= count_limit
                break;
            end

            duplicated = true;
            while duplicated
                map(y, x, :) = gen_();
                duplicated = false;
                for y_ = 1:y
                    for x_ = 1:size_(2)
                        if x == x_ && y == y_
                            continue
                        end
                        if map(y, x, :) == map(y_, x_, :)
                            duplicated = true;
                            break;
                        end
                    end
                end
            end
            count = count + 1;
        end
    end
end
