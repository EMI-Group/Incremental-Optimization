for i=1:15
    filename = sprintf('bestsf%02d.txt', i); 
    data = load(filename);

    meanfilename = sprintf('meanf%02d.txt', i); 
    stdfilename = sprintf('stdf%02d.txt', i); 
    medianfilename = sprintf('medianf%02d.txt', i); 
    fidmean = fopen(meanfilename, 'w');
    fidstd = fopen(stdfilename, 'w');
    fidmedian = fopen(medianfilename, 'w');
    fprintf(fidmean, "%.4e\n", mean(data));
    fprintf(fidstd, "%.4e\n", std(data));
    fprintf(fidmedian, "%.4e\n", median(data));

    close all;
end

