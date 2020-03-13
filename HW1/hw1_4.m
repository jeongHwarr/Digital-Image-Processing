clear all;

[file,path] = uigetfile('*_road_*.jpg');
[filepath,name,ext] = fileparts(file);

image = imread(file);

%% [a] plot histogram (pdf)

imhist(image); 
histogram(image,'normalization','pdf');
title ('Histogram (pdf)')
ylim([0 0.20]);

output_dir_4_a = fullfile(path,'output','4_a');
mkdir(output_dir_4_a);
saveas(gcf, fullfile(output_dir_4_a,strcat(name,'_hist_pdf.png')));

%% [b] Apply global histogram equalization 

output_dir_4_b = fullfile(path,'output','4_b');
mkdir(output_dir_4_b);

eq_image = histeq(image);
histogram(eq_image,'normalization','pdf');
title ('Histogram (pdf)')
saveas(gcf, fullfile(output_dir_4_b,strcat(name,'_equalized_hist.png')));

subplot(1,2,1), imshow(eq_image);
subplot(1,2,2), histogram(eq_image,'normalization','pdf');
truesize;

imwrite(eq_image,fullfile(output_dir_4_b,strcat(name,'_histeq.png')));
saveas(gcf, fullfile(output_dir_4_b,strcat(name,'.png')));

%% [c] Apply locally adaptive histogram equalization 
output_dir_4_c = fullfile(path,'output','4_c');
mkdir(output_dir_4_c);

adapt = adapthisteq(image);
histogram(adapt,'normalization','pdf');
imwrite(adapt,fullfile(output_dir_4_c,strcat(name,'_local_default.png')));
title ('Histogram (pdf)')
saveas(gcf, fullfile(output_dir_4_c,strcat(name,'_local_hist.png')));

range_num_tiles = 4 : 4 : 32;
range_clip_limit = 0.005 : 0.005 : 0.02;

for num_tiles = range_num_tiles
    for clip_limit = range_clip_limit
        adapt = adapthisteq(image,'NumTiles',[num_tiles num_tiles],'ClipLimit',clip_limit);
        imwrite(adapt,fullfile(output_dir_4_c,strcat(name,'_local_',num2str(num_tiles,'%2d'),'_',num2str(clip_limit,'%1.3f'),'.png')));
    end
end
