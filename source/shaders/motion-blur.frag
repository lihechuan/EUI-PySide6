#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;
layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float amount;
    vec2 direction;
};
layout(binding = 1) uniform sampler2D source;
void main() { vec2 offset = direction * amount; vec4 color = texture(source, qt_TexCoord0) * 0.4; color += texture(source, qt_TexCoord0 + offset) * 0.2; color += texture(source, qt_TexCoord0 - offset) * 0.2; color += texture(source, qt_TexCoord0 + offset * 2.0) * 0.1; color += texture(source, qt_TexCoord0 - offset * 2.0) * 0.1; fragColor = color * qt_Opacity; }
