

clear all;

[file,path] = uigetfile('*.hdr');
[filepath,name,ext] = fileparts(file);

hdr = hdrread(file);
gray_hdr = rgb2gray(hdr);

%% [b] Show gray images

subplot(1,2,1), imshow(hdr);
subplot(1,2,2), imshow(gray_hdr);
truesize 

output_dir_1_b = fullfile(path,'output','1_b');
mkdir(output_dir_1_b);
imwrite(gray_hdr,fullfile(output_dir_1_b,strcat(name,'_gray.png')));  

%% [c] Apply a gamma-nonlinearity (to grayscale images)

output_dir_1_c = fullfile(path,'output','1_c');
mkdir(output_dir_1_c);

for gamma=0.50:0.25:5.0
    
    mapping_hdr = power(gray_hdr,1/gamma);
    %imshow(mapping_hdr);
    imwrite(mapping_hdr,fullfile(output_dir_1_c,strcat(name,'_',num2str(gamma,'%1.2f'),'.png')));   
end

%% [d] Apply a gamma-nonlinearity (to rgb components)

output_dir_1_d = fullfile(path,'output','1_d');
mkdir(output_dir_1_d);

[r,g,b] = get_rgb_component(hdr);

init_val=0.50;
step_size=0.50;
final_val=5.00;  

for r_gamma = init_val:step_size:final_val
    processed_r = power(r,1/r_gamma);
    for g_gamma = init_val:step_size:final_val
        processed_g = power(g,1/g_gamma);
        for b_gamma = init_val:step_size:final_val
            processed_b = power(b,1/b_gamma);
            rgb_image = cat(3, processed_r, processed_g, processed_b);
            imwrite(rgb_image,fullfile(output_dir_1_d,strcat(name,'_',num2str(r_gamma,'%1.2f'),'_',num2str(g_gamma,'%1.2f'),'_',num2str(b_gamma,'%1.2f'),'.png')));
        end
    end
end

function [r,g,b] = get_rgb_component(image)
    r=image(:,:,1);
    g=image(:,:,2);
    b=image(:,:,3);
end

