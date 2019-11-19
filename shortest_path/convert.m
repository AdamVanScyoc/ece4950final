function ops = convert(path)

diff1 = 0;
diff2 = 0;
num_diff = 0;

if (length(path) >= 1)
    for i = 1:length(path)-1
        word1 = path(i);
        word2 = path(i+1);
        word1 = word1{1};
        word2 = word2{1};

        diff1 = 0;
        diff2 = 0;
        num_diff = 0;

        for j = 1:length(word1)
            if (word1(j) ~= word2(j))
               if (num_diff == 0)
                   diff1 = j;
                   num_diff = num_diff + 1;
               elseif (num_diff == 1)
                   diff2 = j;
                   num_diff = num_diff + 1;
               end 
            end
        end


        if (word1(diff1) == 'X')
            ops(i,2) = diff1;
            ops(i,1) = diff2;
        elseif (word1(diff2) == 'X')
            ops(i,2) = diff2;
            ops(i,1) = diff1;
        end
    end
else
    ops = [];
end
end