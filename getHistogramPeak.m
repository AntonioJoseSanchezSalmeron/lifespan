function peak = getHistogramPeak(circuloI)
    hist = zeros(1,256);
    for i=1:size(circuloI)
        hist(circuloI(i)+1) = hist(circuloI(i)+1) + 1;
    end
    
    maxim = 0;
    for i = 1:256
        if (hist(i) > maxim)
            maxim = hist(i);
            peak = i-1;
        end
    end
end