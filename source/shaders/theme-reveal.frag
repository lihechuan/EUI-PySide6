#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;
layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float revealRadius;
    float sourceWidth;
    float sourceHeight;
    vec4 oldBackgroundColor;
};
layout(binding = 1) uniform sampler2D source;
void main() {
                vec2 pixel = qt_TexCoord0 * vec2(sourceWidth, sourceHeight);
                float distanceToOrigin = distance(pixel, vec2(sourceWidth, 0.0));
                float oldFrameMask = step(revealRadius, distanceToOrigin);
                vec4 oldContent = texture(source, qt_TexCoord0);
                vec4 oldFrame = oldBackgroundColor * (1.0 - oldContent.a) + oldContent;
                fragColor = oldFrame * oldFrameMask * qt_Opacity;
            }
