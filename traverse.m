function path = traverse(startpos, endpos)

words = unique(perms(startpos),'row');

adjmat = zeros(length(words),length(words));

for r = 1:length(words)
    for c = 1:length(words)
        if (are_neighbors(words(r,:),words(c,:)) == true)
            adjmat(r,c) = 1;
            adjmat(c,r) = 1;
        end
    end
end

words = cellstr(words);
G = graph(adjmat, words);

plot(G);

path = shortestpath(G, startpos, endpos)

end


