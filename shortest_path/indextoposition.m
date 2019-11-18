function [angle, position] = indextoposition(index)

    if (index == 1)
        angle = '26';
        position = '0';
    elseif (index == 2)
        angle = '60';
        position = '1';
    elseif (index == 3)
        angle = '90';
        position = '0';
    elseif (index == 4)
        angle = '120';
        position = '1';
    elseif (index == 5)
        angle = '156';
        position = '0';
    elseif (index == 6)
        angle = '196';
        position = '1';
    elseif (index == 7)
        angle = '226';
        position = '0';
    elseif (index == 8)
        angle = '271';
        position = '1';
    elseif (index == 9)
        angle = '316';
        position = '0';
    elseif (index == 10)
        angle = '346';
        position = '1';
    end
end