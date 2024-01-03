%% for weight c1
function [output_onepxl_combined] = ROAD1(input_cell_R,input_cell_G,input_cell_B)
    output_onepxl_combined = zeros(1, 3);
    %% Define medium origin cell
    medium_pxl_origin_R = single(input_cell_R(2,2));
    medium_pxl_origin_G = single(input_cell_G(2,2));
    medium_pxl_origin_B = single(input_cell_B(2,2));

    %% 定義定點數的最小精度是二進制的小數點後第幾位
    fractionLength = 16;

    %% Define up road kernel
    Kernel1_1 = single([
        [ 0.02518944,  0.02598884,  0.01707202];
        [-0.0382742 , -0.06739106, -0.03671804];
        [ 0.00116151,  0.0272009 ,  0.01162431];
        [ 0.07102849,  0.05401145,  0.04370438];
        [-0.096949  , -0.09208135, -0.09059542];
        [ 0.05502431,  0.06638402,  0.06604072];
        [ 0.04778805,  0.01297635,  0.00782022];
        [-0.06594153, -0.02958068, -0.0247988 ];
        [ 0.01089667, -0.00285723,  0.01311818]
    ]);
    
    Kernel1_2 = single([
         [ 0.00245886 , 0.01196435 , 0.01851779];
         [ 0.00494925 ,-0.02194896 ,-0.02938477];
         [ 0.01557881 , 0.02171427 , 0.0275145 ];
         [-0.3266679  , 0.04373242 , 0.05261397];
         [-0.02944153 ,-0.22364658 ,-0.03691434];
         [ 0.07863054 ,-0.00114387 ,-0.18880686];
         [ 0.0329187  , 0.02680504 , 0.02701004];
         [-0.00764117 ,-0.03949166 ,-0.03509079];
         [ 0.01513088 , 0.04197465 , 0.03176295]
    ]);
    
    Kernel1_3 = single([
        [ 0.0045336 , -0.00336164 ,-0.01492641];
        [ 0.01007204,  0.01557605 , 0.00933205];
        [-0.01190206, -0.00920787 , 0.00390643];
        [ 0.04887144,  0.0091082  ,-0.00189925];
        [ 0.00872103, -0.00316578 ,-0.01072783];
        [ 0.0104428 ,  0.04408085 , 0.05675472];
        [-0.012202  , -0.00670286 ,-0.0108416 ];
        [ 0.03422729,  0.0083064  ,-0.00320656];
        [-0.03195157, -0.01114457 , 0.00606479]
    ]);
    
    %% 將Kernel中的數值轉換成為定點數
    Kernel1_1 = convertToFixedPoint(Kernel1_1, fractionLength);
    Kernel1_2 = convertToFixedPoint(Kernel1_2, fractionLength);
    Kernel1_3 = convertToFixedPoint(Kernel1_3, fractionLength);

    %% 將原始 kernels 重新排列成三個獨立的通道
    kernel_1_1_R = reshape(Kernel1_1(:, 1)', 3, 3)';
    kernel_1_1_G = reshape(Kernel1_1(:, 2)', 3, 3)';
    kernel_1_1_B = reshape(Kernel1_1(:, 3)', 3, 3)';
    
    kernel_1_2_R = reshape(Kernel1_2(:, 1)', 3, 3)';
    kernel_1_2_G = reshape(Kernel1_2(:, 2)', 3, 3)';
    kernel_1_2_B = reshape(Kernel1_2(:, 3)', 3, 3)';
    
    kernel_1_3_R = reshape(Kernel1_3(:, 1)', 3, 3)';
    kernel_1_3_G = reshape(Kernel1_3(:, 2)', 3, 3)';
    kernel_1_3_B = reshape(Kernel1_3(:, 3)', 3, 3)';
    
    
%     % 顯示結果
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
    biases_up_R = single(0.01160619);
    biases_up_G = single(0.0102302);
    biases_up_B = single(0.00958488);

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
        [-5.89804575e-02, -6.76243231e-02, -1.83445364e-02];
        [-1.34120807e-02,  2.09102333e-01, -4.07016203e-02];
        [ 3.53678857e-04, -1.88464224e-01, -1.49013534e-01];
        [ 4.58846893e-03, -1.04794696e-01, -1.60144135e-01];
        [-1.11057006e-01,  5.46797737e-02, -1.35847135e-02];
        [ 2.22384222e-02, -4.93405834e-02, -5.38774282e-02];
        [-8.08959007e-02,  2.73192283e-02,  5.24635911e-02];
        [-7.09331930e-02, -3.90116684e-02, -3.76796089e-02];
        [-5.08269891e-02,  9.81170610e-02, -1.51143134e-01]
    ]);
    
    Kernel2_2 = single([
        [ 2.17458024e-03 ,-9.08778831e-02, -2.42486689e-02];
        [-1.06312476e-01 ,-6.37254566e-02, -4.64905463e-02];
        [-7.82197807e-03 , 9.76785272e-02, -1.73115566e-01];
        [-1.42945960e-01 ,-6.15531318e-02,  7.01852515e-03];
        [-2.70338338e-02 ,-4.78137970e-01,  7.22261742e-02];
        [ 4.85254675e-02 , 1.97003171e-01, -1.79577723e-01];
        [ 7.86212906e-02 ,-4.73486893e-02, -5.76661639e-02];
        [-4.89308275e-02 , 6.76617771e-02,  3.69743407e-02];
        [-1.43832475e-01 ,-1.70694683e-02, -3.64543833e-02]
    ]);
    
    Kernel2_3 = single([
        [-3.29673141e-02 , 1.71824992e-02, -5.46223596e-02];
        [-1.48475885e-01 , 6.28812537e-02,  8.72605070e-02];
        [-6.26114234e-02 ,-5.00660501e-02, -9.67221335e-02];
        [ 4.53137867e-02 ,-2.52369829e-02, -9.41368490e-02];
        [-2.14102089e-01 , 9.33011845e-02, -1.02301203e-01];
        [-8.07517841e-02 ,-6.86144903e-02, -3.33689898e-02];
        [-1.04667358e-01 ,-2.20873561e-02, -2.25482807e-01];
        [-1.95012122e-01 , 9.91555005e-02, -4.76259552e-02];
        [ 4.16768789e-02 ,-5.56232519e-02,  1.05287731e-01]
    ]);
    %% 將kernel中的數值轉換成定點數
    Kernel2_1 = convertToFixedPoint(Kernel2_1, fractionLength);
    Kernel2_2 = convertToFixedPoint(Kernel2_2, fractionLength);
    Kernel2_3 = convertToFixedPoint(Kernel2_3, fractionLength);

    %% 將原始 kernels 重新排列成三個獨立的通道
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
%     
    %% Define down road biases
    % biases
    biases_down_R = single(-7.1018763e-02);
    biases_down_G = single(5.2744934e-05);
    biases_down_B = single(-9.2865236e-02);
    
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