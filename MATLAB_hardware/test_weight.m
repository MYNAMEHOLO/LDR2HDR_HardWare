%% Define the kernel part
% Define input cell here
input_cell_R = ones(3, 3);
input_cell_G = ones(3, 3);
input_cell_B = ones(3, 3);
output_onepxl_combined = zeros(1, 3);
    %% Define medium origin cell
    %% operation here
    medium_pxl_origin_R = single(input_cell_R(2,2));
    medium_pxl_origin_G = single(input_cell_G(2,2));
    medium_pxl_origin_B = single(input_cell_B(2,2));
    %% Define up road kernel
    Kernel1_1 = single([
        [-0.06060344, -0.20460482, -0.08648768];
        [-0.13098375, -0.18236682, -0.04203524];
        [-0.07995155, -0.17219122, -0.34147492];
        [-0.03396509, -0.14037307, -0.4418903 ];
        [-0.05015077, -0.21383542, -0.32623577];
        [-0.08161981, -0.24753736, -0.29881635];
        [-0.07301063, -0.20476876, -0.09956616];
        [-0.18122287, -0.21282151, -0.20071869];
        [-0.08938497, -0.18235026, -0.3513788 ];
    ]);
    
    Kernel1_2 = single([
        [-0.11982842, -0.16076611, -0.15279952];
        [-0.1017948,  -0.17278977, -0.08266857];
        [-0.18122852, -0.2741138,  -0.19576831];
        [-0.10999158, -0.18700002, -0.474123  ];
        [-0.23689528, -0.41602486, -0.3944591 ];
        [-0.03173373, -0.20483203, -0.43647957];
        [-0.10676891, -0.1609501,   0.01821824];
        [-0.09051172, -0.31856722,  0.05868365];
        [-0.14550157, -0.2958981,  -0.35680166];
    ]);
    
    Kernel1_3 = single([
        [-0.12349594, -0.1662659,  -0.05847446];
        [-0.23301889, -0.40170017, -0.05558959];
        [-0.15040772, -0.1945282,  -0.03569927];
        [-0.10655447, -0.15637524, -0.4309419 ];
        [-0.12091178, -0.29637155, -0.18779853];
        [-0.17626177, -0.29933086, -0.58591115];
        [-0.10382496, -0.25569212,  0.01267383];
        [-0.23597006, -0.27617544,  0.08157416];
        [-0.13692373, -0.16659334, -0.2798427 ];
    ]);
    
    % 將原始 kernels 重新排列成三個獨立的通道
    kernel_1_1_R = reshape(Kernel1_1(:, 1)', 3, 3)';
    kernel_1_1_G = reshape(Kernel1_1(:, 2)', 3, 3)';
    kernel_1_1_B = reshape(Kernel1_1(:, 3)', 3, 3)';
    
    kernel_1_2_R = reshape(Kernel1_2(:, 1)', 3, 3)';
    kernel_1_2_G = reshape(Kernel1_2(:, 2)', 3, 3)';
    kernel_1_2_B = reshape(Kernel1_2(:, 3)', 3, 3)';
    
    kernel_1_3_R = reshape(Kernel1_3(:, 1)', 3, 3)';
    kernel_1_3_G = reshape(Kernel1_3(:, 2)', 3, 3)';
    kernel_1_3_B = reshape(Kernel1_3(:, 3)', 3, 3)';
    
    
    % 顯示結果
    disp('Kernel 1 for Red Channel (kernel_1_1_R):');
    disp(kernel_1_1_R);
    disp('Kernel 1 for Green Channel (kernel_1_1_G):');
    disp(kernel_1_1_G);
    disp('Kernel 1 for Blue Channel (kernel_1_1_B):');
    disp(kernel_1_1_B);
    
    disp('Kernel 2 for Red Channel (kernel_1_2_R):');
    disp(kernel_1_2_R);
    disp('Kernel 2 for Green Channel (kernel_1_2_G):');
    disp(kernel_1_2_G);
    disp('Kernel 2 for Blue Channel (kernel_1_2_B):');
    disp(kernel_1_2_B);
    
    
    
    disp('Kernel 3 for Red Channel (kernel_1_3_R):');
    disp(kernel_1_3_R);
    disp('Kernel 3 for Green Channel (kernel_1_3_G):');
    disp(kernel_1_3_G);
    disp('Kernel 3 for Blue Channel (kernel_1_3_B):');
    disp(kernel_1_3_B);
    
    %% Define up road biases
    % biases
    biases_up_R = single(-0.00010128);
    biases_up_G = single(-0.01732344);
    biases_up_B = single(-0.05164022);
    
    
    % 顯示變數的數值
    disp('biases_up_R:');
    disp(biases_up_R);
    
    disp('biases_up_G:');
    disp(biases_up_G);
    
    disp('biases_up_B:');
    disp(biases_up_B);
    
    %% Define down road kernel
    Kernel2_1 = single([
        [-0.12420122, -0.31055775, -0.6091077];
        [ 0.0042517,  -0.34045333, -0.8115962];
        [-0.07323586, -0.38995138, -0.68804544];
        [-0.02794806, -0.48241475, -0.7952045];
        [-0.06258836, -0.17396103, -0.80040103];
        [-0.16781892, -0.3525624,  -0.44838083];
        [-0.24400057, -0.3752533,  -0.6364181];
        [-0.25503471, -0.35843426, -0.6788668];
        [-0.17756239, -0.29209444, -0.7040479]
    ]);
    
    Kernel2_2 = single([
        [-0.18980305, -0.20623444, -0.78560597];
        [-0.06903154, -0.15056552, -0.73135257];
        [-0.07775745, -0.2920185,  -0.3603318];
        [-0.32650828, -0.26293766, -0.7148962];
        [-0.2455786,  -0.15141924, -0.3922815];
        [-0.36686757, -0.25122055,  0.18371072];
        [-0.13823384, -0.5559223,  -0.78363043];
        [-0.09725386, -0.69811046, -0.73330337];
        [-0.28155798, -0.5660013,  -0.3682009]
    ]);
    
    Kernel2_3 = single([
        [-0.09721049, -0.2647271,  -0.23284753];
        [-0.28195062, -0.31135088, -0.5620714];
        [-0.03210959, -0.20943713, -0.31887877];
        [-0.28080982, -0.50719297, -0.44556144];
        [-0.37070075, -0.58555406, -0.53446686];
        [-0.31613562, -0.5814902,  -0.04479552];
        [-0.25647956, -0.5112833,  -0.2868186];
        [-0.35727176, -0.62352717, -0.43127704];
        [-0.31320935, -0.7209257,  -0.3855296]
    ]);
    
    % 將原始 kernels 重新排列成三個獨立的通道
    kernel_2_1_R = reshape(Kernel2_1(:, 1)', 3, 3)';
    kernel_2_1_G = reshape(Kernel2_1(:, 2)', 3, 3)';
    kernel_2_1_B = reshape(Kernel2_1(:, 3)', 3, 3)';
    
    kernel_2_2_R = reshape(Kernel2_2(:, 1)', 3, 3)';
    kernel_2_2_G = reshape(Kernel2_2(:, 2)', 3, 3)';
    kernel_2_2_B = reshape(Kernel2_2(:, 3)', 3, 3)';
    
    kernel_2_3_R = reshape(Kernel2_3(:, 1)', 3, 3)';
    kernel_2_3_G = reshape(Kernel2_3(:, 2)', 3, 3)';
    kernel_2_3_B = reshape(Kernel2_3(:, 3)', 3, 3)';
    
    
    % 顯示結果
    disp('Kernel 2-1 for Red Channel (kernel_2_1_R):');
    disp(kernel_2_1_R);
    disp('Kernel 2-1 for Green Channel (kernel_2_1_G):');
    disp(kernel_2_1_G);
    disp('Kernel 2-1 for Blue Channel (kernel_2_1_B):');
    disp(kernel_2_1_B);
    
    disp('Kernel 2-2 for Red Channel (kernel_2_2_R):');
    disp(kernel_2_2_R);
    disp('Kernel 2-2 for Green Channel (kernel_2_2_G):');
    disp(kernel_2_2_G);
    disp('Kernel 2-2 for Blue Channel (kernel_2_2_B):');
    disp(kernel_2_2_B);
    
    disp('Kernel 2-3 for Red Channel (kernel_2_3_R):');
    disp(kernel_2_3_R);
    disp('Kernel 2-3 for Green Channel (kernel_2_3_G):');
    disp(kernel_2_3_G);
    disp('Kernel 2-3 for Blue Channel (kernel_2_3_B):');
    disp(kernel_2_3_B);
    
    %% Define down road biases
    % biases
    biases_down_R = single(-0.13931017);
    biases_down_G = single(-0.39969534);
    biases_down_B = single(-0.45995504);
    
    % 顯示bias數值
    disp('biases_up_R:');
    disp(biases_up_R);
    
    disp('biases_up_G:');
    disp(biases_up_G);
    
    disp('biases_up_B:');
    disp(biases_up_B);
     
    %% 合併Kernel
    Big_Kernel_uproad_R = kernel_1_1_R + kernel_1_2_R + kernel_1_3_R;
    Big_Kernel_uproad_G = kernel_1_1_G + kernel_1_2_G + kernel_1_3_G;
    Big_Kernel_uproad_B = kernel_1_1_B + kernel_1_2_B + kernel_1_3_B;

    Big_Kernel_downroad_R = kernel_2_1_R + kernel_2_2_R + kernel_2_3_R;
    Big_Kernel_downroad_G = kernel_2_1_G + kernel_2_2_G + kernel_2_3_G;
    Big_Kernel_downroad_B = kernel_2_1_B + kernel_2_2_B + kernel_2_3_B;
    
    % 显示结果
    disp('Big Kernel Uproad for Red Channel:');
    disp(Big_Kernel_uproad_R);
    
    disp('Big Kernel Uproad for Green Channel:');
    disp(Big_Kernel_uproad_G);
    
    disp('Big Kernel Uproad for Blue Channel:');
    disp(Big_Kernel_uproad_B);
    
    disp('Big Kernel Downroad for Red Channel:');
    disp(Big_Kernel_downroad_R);
    
    disp('Big Kernel Down for Green Channel:');
    disp(Big_Kernel_downroad_G);
    
    disp('Big Kernel Down for Blue Channel:');
    disp(Big_Kernel_downroad_B);

    %% UP road operation here
    % UP road conv
    output_up_conv_R = custom_conv2(input_cell_R,Big_Kernel_uproad_R);
    output_up_conv_G = custom_conv2(input_cell_G,Big_Kernel_uproad_G);
    output_up_conv_B = custom_conv2(input_cell_B,Big_Kernel_uproad_B);
    
    % Result of uproad conv Display here
    disp('output_up_conv_R');
    disp(output_up_conv_R);
    disp('output_up_conv_G');
    disp(output_up_conv_G);
    disp('output_up_conv_B');
    disp(output_up_conv_B);

    % Up road bias
    output_up_bias_R = output_up_conv_R + biases_up_R;
    output_up_bias_G = output_up_conv_G + biases_up_G;
    output_up_bias_B = output_up_conv_B + biases_up_B;

    % Result of bias display here
    disp('output_up_bias_R');
    disp(output_up_bias_R);
    disp('output_up_bias_G');
    disp(output_up_bias_G);
    disp('output_up_bias_B');
    disp(output_up_bias_B);

    % Up road relu
    output_up_relu_R = relu(output_up_bias_R);
    output_up_relu_G = relu(output_up_bias_G);
    output_up_relu_B = relu(output_up_bias_B);

    % Display up road output relu R,G,B here
    disp('output_up_relu_R');
    disp(output_up_relu_R);
    disp('output_up_relu_G');
    disp(output_up_relu_G);
    disp('output_up_relu_B');
    disp(output_up_relu_B);
    
    % output uproad here;
    output_uproad_R = output_up_relu_R + medium_pxl_origin_R;
    output_uproad_G = output_up_relu_G + medium_pxl_origin_G;
    output_uproad_B = output_up_relu_B + medium_pxl_origin_B;
    
    % display uproad here;
    disp('Output Uproad R:');
    disp(output_uproad_R);
    
    disp('Output Uproad G:');
    disp(output_uproad_G);
    
    disp('Output Uproad B:');
    disp(output_uproad_B);

    %% Down road operation here
    % Down road conv
    output_down_conv_R = custom_conv2(input_cell_R,Big_Kernel_downroad_R);
    output_down_conv_G = custom_conv2(input_cell_G,Big_Kernel_downroad_G);
    output_down_conv_B = custom_conv2(input_cell_B,Big_Kernel_downroad_B);

    % Result of downroad conv Display here
    disp('output_down_conv_R');
    disp(output_down_conv_R);
    disp('output_down_conv_G');
    disp(output_down_conv_G);
    disp('output_down_conv_B');
    disp(output_down_conv_B);

    % Down road bias
    output_down_bias_R = output_down_conv_R + biases_down_R;
    output_down_bias_G = output_down_conv_G + biases_down_G;
    output_down_bias_B = output_down_conv_B + biases_down_B;

    % Result of bias display here
    disp('output_down_bias_R');
     disp(output_down_bias_R);
    disp('output_down_bias_G');
     disp(output_down_bias_G);
    disp('output_down_bias_B');
     disp(output_down_bias_B);

    % Down road relu
    output_down_relu_R = relu(output_down_bias_R);
    output_down_relu_G = relu(output_down_bias_G);
    output_down_relu_B = relu(output_down_bias_B);

    % Display down road output relu R,G,B here
    disp('output_down_relu_R');
     disp(output_down_relu_R);
    disp('output_down_relu_G');
     disp(output_down_relu_G);
    disp('output_down_relu_B');
     disp(output_down_relu_B);

    % output down here;
    output_downroad_R = output_down_relu_R + medium_pxl_origin_R;
    output_downroad_G = output_down_relu_G + medium_pxl_origin_G;
    output_downroad_B = output_down_relu_B + medium_pxl_origin_B;

    % display uproad here;
    disp('Output downroad R:');
     disp(output_downroad_R);
    
    disp('Output downroad G:');
     disp(output_downroad_G);
    
    disp('Output downroad B:');
     disp(output_downroad_B);

    %% Final output 1pxl here
    output_onepxl_R = output_uproad_R + output_downroad_R;
    output_onepxl_G = output_uproad_G + output_downroad_G;
    output_onepxl_B = output_uproad_B + output_downroad_B;

    % 显示结果
    disp('Output One Pixel R:');
    disp(output_onepxl_R);
    
    disp('Output One Pixel G:');
    disp(output_onepxl_G);
    
    disp('Output One Pixel B:');
    disp(output_onepxl_B);

    output_onepxl_combined = cat(3, output_onepxl_R, output_onepxl_G, output_onepxl_B);
    disp('output_onepxl_combined')
    disp(output_onepxl_combined)