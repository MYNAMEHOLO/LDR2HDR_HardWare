%% for weight c3
function [output_onepxl_combined] = ROAD3(input_cell_R,input_cell_G,input_cell_B)
    output_onepxl_combined = zeros(1, 3);
    %% Define medium origin cell
    medium_pxl_origin_R = single(input_cell_R(2,2));
    medium_pxl_origin_G = single(input_cell_G(2,2));
    medium_pxl_origin_B = single(input_cell_B(2,2));

    %% 定義定點數的最小精度是二進制的小數點後第幾位
    fractionLength = 16;

    %% Define up road kernel
    Kernel1_1 = single([
        [ 5.9868231e-02 ,-1.4634589e-03,  7.8645349e-03];
        [-6.6750363e-02 , 5.7874364e-03, -3.6443116e-03];
        [-1.4637753e-02 ,-6.6639618e-03, -1.7399024e-02];
        [-1.6463908e-03 ,-3.1428600e-03,  8.4818387e-03];
        [-5.8286847e-03 , 1.8381074e-02, -4.0557746e-02];
        [-2.6364693e-02 , 4.2579625e-02,  6.6710949e-02];
        [-1.2719762e-02 ,-2.6640014e-03, -7.3121642e-03];
        [ 8.1084557e-03 , 6.7785122e-03, -3.8692746e-03];
        [-4.0958170e-02 ,-1.7040479e-04, -9.9266274e-03]
    ]);
    
    Kernel1_2 = single([
        [-1.3173996e-01 , 2.3199918e-02,  2.4709366e-02];
        [-2.0528132e-02 ,-2.8849391e-02, -6.5565310e-02];
        [ 4.4014767e-02 , 3.0067472e-02,  5.2104402e-02];
        [-4.5034260e-01 , 3.6451437e-02,  4.0627237e-02];
        [-9.5992118e-02 ,-2.0109874e-01, -2.4023589e-02];
        [ 1.7264344e-01 ,-4.0231049e-03, -1.6071784e-01];
        [-1.4460981e-01 , 9.0583693e-03,  1.9283665e-02];
        [-6.7050673e-02 ,-9.0855099e-03, -6.1358944e-02];
        [ 7.9073317e-02 , 1.7664330e-02,  5.5885814e-02]
    ]);
    
    Kernel1_3 = single([
        [-1.4249548e-01,  1.9538304e-02 ,-2.1852682e+00];
        [-2.1612892e-01, -5.1082194e-02 ,-2.0533009e+00];
        [-3.1030577e-01,  1.8669853e-02 ,-1.9135691e+00];
        [-1.2427018e-01,  5.1874071e-02 ,-2.7015922e+00];
        [-1.9534102e-01, -8.3424866e-02 ,-2.4109495e+00];
        [-4.5119750e-01,  5.9011959e-02 ,-2.0660388e+00];
        [-3.1711757e-01,  2.0392880e-02 ,-1.7799388e+00];
        [-3.4520376e-01, -6.7708522e-02 ,-1.6284275e+00];
        [-3.6518499e-01,  3.0532248e-02 ,-1.5905745e+00]
    ]);
    
    %% 將Kernel中的數值轉換成為定點數
    Kernel1_1 = convertToFixedPoint(Kernel1_1, fractionLength);
    Kernel1_2 = convertToFixedPoint(Kernel1_2, fractionLength);
    Kernel1_3 = convertToFixedPoint(Kernel1_3, fractionLength);

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
%     disp('Kernel 1 for Red Channel (kernel_1_1_R):');
%     disp(kernel_1_1_R);
%     disp('Kernel 1 for Green Channel (kernel_1_1_G):');
%     disp(kernel_1_1_G);
%     disp('Kernel 1 for Blue Channel (kernel_1_1_B):');
%     disp(kernel_1_1_B);
%     
%     disp('Kernel 2 for Red Channel (kernel_1_2_R):');
%     disp(kernel_1_2_R);
%     disp('Kernel 2 for Green Channel (kernel_1_2_G):');
%     disp(kernel_1_2_G);
%     disp('Kernel 2 for Blue Channel (kernel_1_2_B):');
%     disp(kernel_1_2_B);
%     
%     
%     
%     disp('Kernel 3 for Red Channel (kernel_1_3_R):');
%     disp(kernel_1_3_R);
%     disp('Kernel 3 for Green Channel (kernel_1_3_G):');
%     disp(kernel_1_3_G);
%     disp('Kernel 3 for Blue Channel (kernel_1_3_B):');
%     disp(kernel_1_3_B);
    
    %% Define up road biases
    % biases
    biases_up_R = single(0.00328499);
    biases_up_G = single(0.00808754);
    biases_up_B = single(0.01405627);
    
    % 將bias轉成定點數
    biases_up_R = floatToFixedPoint(biases_up_R, fractionLength);
    biases_up_G = floatToFixedPoint(biases_up_G, fractionLength);
    biases_up_B = floatToFixedPoint(biases_up_B, fractionLength);
    
%     % 顯示變數的數值
%     disp('biases_up_R:');
%     disp(biases_up_R);
%     
%     disp('biases_up_G:');
%     disp(biases_up_G);
%     
%     disp('biases_up_B:');
%     disp(biases_up_B);
    
    %% Define down road kernel
    Kernel2_1 = single([
        [-7.03298766e-03 ,-8.93968996e-03, -1.74831510e-01];
        [ 1.81877092e-02 , 4.90569659e-02, -3.57417502e-02];
        [-2.05918439e-02 ,-3.76718380e-02, -3.31932828e-02];
        [ 3.39850858e-02 ,-6.27397839e-03, -1.48143664e-01];
        [ 7.94974994e-03 , 7.31026977e-02,  2.08618809e-02];
        [ 1.42144747e-02 ,-4.97986637e-02, -1.01078577e-01];
        [ 1.93357654e-02 ,-6.01037070e-02, -8.24209526e-02];
        [-1.17024314e-02 , 9.47809890e-02, -1.05325229e-01];
        [-1.00171380e-02 ,-9.46013629e-02, -1.59802645e-01]
    ]);
    
    Kernel2_2 = single([
        [ 1.51699372e-02 ,-6.70749173e-02 ,-7.40479082e-02];
        [ 1.38677284e-02 ,-4.37971717e-03 ,-9.68415011e-03];
        [-3.96573101e-04 , 4.86244401e-03 ,-1.25187978e-01];
        [-2.59960115e-01 ,-7.62328655e-02 ,-1.24203824e-01];
        [ 3.02075129e-02 ,-6.04889989e-01 , 3.40972245e-02];
        [ 2.05771383e-02 , 2.19352514e-01 ,-2.20822617e-02];
        [-4.25311737e-03 ,-9.18011144e-02 ,-1.05095297e-01];
        [ 3.91471647e-02 ,-4.06433493e-02 , 3.27929035e-02];
        [-1.08940369e-02 , 1.01728693e-01 ,-5.47178127e-02]
    ]);
    
    Kernel2_3 = single([
        [ 5.23155555e-02, -8.22379142e-02 ,-1.94218997e-02];
        [-8.62723365e-02,  3.15828174e-02 , 2.16274280e-02];
        [ 2.53820606e-02, -1.11226132e-02 , 5.05320728e-03];
        [ 5.96866570e-02, -1.09155178e-01 ,-1.11904345e-01];
        [-8.78022760e-02,  5.10885641e-02 ,-2.04876915e-01];
        [ 5.94749860e-02,  2.05776710e-02 , 3.14404219e-02];
        [ 2.51547899e-02, -8.66671130e-02 ,-9.86254215e-02];
        [-4.24132124e-02,  2.30309203e-01 ,-1.45615205e-01];
        [ 1.10241333e-02, -2.12720141e-01 ,-8.03630054e-02]
    ]);

    %% 將kernel中的數值轉換成定點數
    Kernel2_1 = convertToFixedPoint(Kernel2_1, fractionLength);
    Kernel2_2 = convertToFixedPoint(Kernel2_2, fractionLength);
    Kernel2_3 = convertToFixedPoint(Kernel2_3, fractionLength);

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
    
    
%     % 顯示結果
%     disp('Kernel 2-1 for Red Channel (kernel_2_1_R):');
%     disp(kernel_2_1_R);
%     disp('Kernel 2-1 for Green Channel (kernel_2_1_G):');
%     disp(kernel_2_1_G);
%     disp('Kernel 2-1 for Blue Channel (kernel_2_1_B):');
%     disp(kernel_2_1_B);
%     
%     disp('Kernel 2-2 for Red Channel (kernel_2_2_R):');
%     disp(kernel_2_2_R);
%     disp('Kernel 2-2 for Green Channel (kernel_2_2_G):');
%     disp(kernel_2_2_G);
%     disp('Kernel 2-2 for Blue Channel (kernel_2_2_B):');
%     disp(kernel_2_2_B);
%     
%     disp('Kernel 2-3 for Red Channel (kernel_2_3_R):');
%     disp(kernel_2_3_R);
%     disp('Kernel 2-3 for Green Channel (kernel_2_3_G):');
%     disp(kernel_2_3_G);
%     disp('Kernel 2-3 for Blue Channel (kernel_2_3_B):');
%     disp(kernel_2_3_B);
    
    %% Define down road biases
    % biases
    biases_down_R = single( 0.00845672);
    biases_down_G = single(0.00113662);
    biases_down_B = single(-0.08180095);
    
    % 將bias轉換成為定點數
    biases_down_R = floatToFixedPoint(biases_down_R, fractionLength);
    biases_down_G = floatToFixedPoint(biases_down_G, fractionLength);
    biases_down_B = floatToFixedPoint(biases_down_B, fractionLength);
%     % 顯示bias數值
%     disp('biases_up_R:');
%     disp(biases_up_R);
%     
%     disp('biases_up_G:');
%     disp(biases_up_G);
%     
%     disp('biases_up_B:');
%     disp(biases_up_B);
     
    %% operation here
                %% 合併Kernel
    Big_Kernel_uproad_R = kernel_1_1_R + kernel_1_2_R + kernel_1_3_R;
    Big_Kernel_uproad_G = kernel_1_1_G + kernel_1_2_G + kernel_1_3_G;
    Big_Kernel_uproad_B = kernel_1_1_B + kernel_1_2_B + kernel_1_3_B;

    Big_Kernel_downroad_R = kernel_2_1_R + kernel_2_2_R + kernel_2_3_R;
    Big_Kernel_downroad_G = kernel_2_1_G + kernel_2_2_G + kernel_2_3_G;
    Big_Kernel_downroad_B = kernel_2_1_B + kernel_2_2_B + kernel_2_3_B;
    
%     % 显示结果
%     disp('Big Kernel Uproad for Red Channel:');
%     disp(Big_Kernel_uproad_R);
%     
%     disp('Big Kernel Uproad for Green Channel:');
%     disp(Big_Kernel_uproad_G);
%     
%     disp('Big Kernel Uproad for Blue Channel:');
%     disp(Big_Kernel_uproad_B);
%     
%     disp('Big Kernel Downroad for Red Channel:');
%     disp(Big_Kernel_downroad_R);
%     
%     disp('Big Kernel Down for Green Channel:');
%     disp(Big_Kernel_downroad_G);
%     
%     disp('Big Kernel Down for Blue Channel:');
%     disp(Big_Kernel_downroad_B);

    %% UP road operation here
    % UP road conv
    output_up_conv_R = custom_conv2(input_cell_R,Big_Kernel_uproad_R);
    output_up_conv_G = custom_conv2(input_cell_G,Big_Kernel_uproad_G);
    output_up_conv_B = custom_conv2(input_cell_B,Big_Kernel_uproad_B);
    
%     % Result of uproad conv Display here
%     disp('output_up_conv_R');
%     disp(output_up_conv_R);
%     disp('output_up_conv_G');
%     disp(output_up_conv_G);
%     disp('output_up_conv_B');
%     disp(output_up_conv_B);

    % Up road bias
    output_up_bias_R = output_up_conv_R + biases_up_R;
    output_up_bias_G = output_up_conv_G + biases_up_G;
    output_up_bias_B = output_up_conv_B + biases_up_B;

%     % Result of bias display here
%     disp('output_up_bias_R');
%     disp(output_up_bias_R);
%     disp('output_up_bias_G');
%     disp(output_up_bias_G);
%     disp('output_up_bias_B');
%     disp(output_up_bias_B);

    % Up road relu
    output_up_relu_R = relu(output_up_bias_R);
    output_up_relu_G = relu(output_up_bias_G);
    output_up_relu_B = relu(output_up_bias_B);

%     % Display up road output relu R,G,B here
%     disp('output_up_relu_R');
%     disp(output_up_relu_R);
%     disp('output_up_relu_G');
%     disp(output_up_relu_G);
%     disp('output_up_relu_B');
%     disp(output_up_relu_B);
    
    % output uproad here;
    output_uproad_R = output_up_relu_R + medium_pxl_origin_R;
    output_uproad_G = output_up_relu_G + medium_pxl_origin_G;
    output_uproad_B = output_up_relu_B + medium_pxl_origin_B;
    
%     % display uproad here;
%     disp('Output Uproad R:');
%     disp(output_uproad_R);
%     
%     disp('Output Uproad G:');
%     disp(output_uproad_G);
%     
%     disp('Output Uproad B:');
%     disp(output_uproad_B);

    %% Down road operation here
    % Down road conv
    output_down_conv_R = custom_conv2(input_cell_R,Big_Kernel_downroad_R);
    output_down_conv_G = custom_conv2(input_cell_G,Big_Kernel_downroad_G);
    output_down_conv_B = custom_conv2(input_cell_B,Big_Kernel_downroad_B);

%     % Result of downroad conv Display here
%     disp('output_down_conv_R');
%     disp(output_down_conv_R);
%     disp('output_down_conv_G');
%     disp(output_down_conv_G);
%     disp('output_down_conv_B');
%     disp(output_down_conv_B);

    % Down road bias
    output_down_bias_R = output_down_conv_R + biases_down_R;
    output_down_bias_G = output_down_conv_G + biases_down_G;
    output_down_bias_B = output_down_conv_B + biases_down_B;

%     % Result of bias display here
%     disp('output_down_bias_R');
%      disp(output_down_bias_R);
%     disp('output_down_bias_G');
%      disp(output_down_bias_G);
%     disp('output_down_bias_B');
%      disp(output_down_bias_B);

    % Down road relu
    output_down_relu_R = relu(output_down_bias_R);
    output_down_relu_G = relu(output_down_bias_G);
    output_down_relu_B = relu(output_down_bias_B);

%     % Display down road output relu R,G,B here
%     disp('output_down_relu_R');
%      disp(output_down_relu_R);
%     disp('output_down_relu_G');
%      disp(output_down_relu_G);
%     disp('output_down_relu_B');
%      disp(output_down_relu_B);

    % output down here;
    output_downroad_R = output_down_relu_R + medium_pxl_origin_R;
    output_downroad_G = output_down_relu_G + medium_pxl_origin_G;
    output_downroad_B = output_down_relu_B + medium_pxl_origin_B;

%     % display uproad here;
%     disp('Output downroad R:');
%      disp(output_downroad_R);
%     
%     disp('Output downroad G:');
%      disp(output_downroad_G);
%     
%     disp('Output downroad B:');
%      disp(output_downroad_B);

    %% Final output 1pxl here
    output_onepxl_R = output_uproad_R + output_downroad_R;
    output_onepxl_G = output_uproad_G + output_downroad_G;
    output_onepxl_B = output_uproad_B + output_downroad_B;

%     % 显示结果
%     disp('Output One Pixel R:');
%     disp(output_onepxl_R);
%     
%     disp('Output One Pixel G:');
%     disp(output_onepxl_G);
%     
%     disp('Output One Pixel B:');
%     disp(output_onepxl_B);

    % 將所有輸出定點
    output_onepxl_R = floatToFixedPoint(output_onepxl_R, fractionLength);
    output_onepxl_G = floatToFixedPoint(output_onepxl_G, fractionLength);
    output_onepxl_B = floatToFixedPoint(output_onepxl_B, fractionLength);
    
    % 确保所有输入都是 single 类型
    output_onepxl_R = single(output_onepxl_R);
    output_onepxl_G = single(output_onepxl_G);
    output_onepxl_B = single(output_onepxl_B);
    
    % 将 RGB 三个通道乘以 16 并限定最大值不超过 16
    output_onepxl_R_scaled = min(output_onepxl_R * 16, 16);
    output_onepxl_G_scaled = min(output_onepxl_G * 16, 16);
    output_onepxl_B_scaled = min(output_onepxl_B * 16, 16);
    
    % 将 RGB 三个通道合并
    output_onepxl_combined = cat(3, output_onepxl_R_scaled, output_onepxl_G_scaled, output_onepxl_B_scaled);
    %     % 顯示結果
    %     disp('output_onepxl_combined')
    %     disp(output_onepxl_combined)


end