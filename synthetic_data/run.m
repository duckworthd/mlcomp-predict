clear;
%%
dims = [10 1000 10000];
num_sampleses = [7500];
num_classeses = [3 20];
densities = [0.1, 0.5, 0.75, 1];

%%
for dim=dims
    for num_samples=num_sampleses
        for num_classes=num_classeses
            for d=densities
                density = struct('input', d);
                output_file = sprintf('synthetic-%d-%d-%d-%0.2f.txt', ...
                    dim, num_samples,num_classes, density.input);
                
                [samples, classes, weights] = generate_class(...
                    dim, num_samples, num_classes, density);
                save_class(samples, classes, output_file);
            end
        end
    end
end
