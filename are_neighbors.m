function TF = are_neighbors(a,b)
num_difference = 0;
TF = false;
for i = 1:length(a)
    if (a(i) ~= b(i))
        num_difference = num_difference + 1;

        if (num_difference == 1)
            pos1_diff = i;
        elseif (num_difference == 2)
            pos2_diff = i;
        end
    end
end

if (num_difference == 2)
    if (((a(pos1_diff) == 'X' & a(pos2_diff) ~= 'X') | (b(pos1_diff) ~= 'X' & b(pos2_diff) == 'X')) & a(pos1_diff) == b(pos2_diff))
        TF = true;
    end
end
end