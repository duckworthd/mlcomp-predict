clear;

%%

[samples, class] = generate_class(10, 100, 3, 0.75, 0.75, 0.9);

%%
save_class(samples, class, 'output.txt');