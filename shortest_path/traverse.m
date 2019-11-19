function path = traverse(startpos, endpos)

words = unique(perms(startpos),'rows');

adjmat = zeros(length(words),length(words));

for r = 1:length(words)
    for c = 1:length(words)
        if (are_neighbors(words(r,:),words(c,:)) == true)
            adjmat(r,c) = 1;
            adjmat(c,r) = 1;
        end
    end
    
    if (mod(r, length(words) / 5) == 0)
        fprintf("Iteration %d of %d\n", r, length(words));
    end
end

words = cellstr(words);
G = graph(adjmat, words);

% plot(G);

path = shortestpath(G, startpos, endpos)

if (length(path) == 1)
   path = {}; 
end

end


