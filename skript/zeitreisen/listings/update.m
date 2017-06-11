function update
    s=1 * (0:ss:N);
    hold off;
    x0 = mnormalize(x0);
    solution = geodesic(x0, s);
    polarplot(solution(:,5),solution(:,3))
    solution(size(solution,1),:)
    drawEventHorizon;
end
