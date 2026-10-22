#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;
layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec4 newBackgroundColor;
    vec4 oldBackgroundColor;
    float darkTarget;
    float progress;
    float maximumRadius;
    vec2 origin;
    vec2 switchOrigin;
    vec2 switchSize;
    vec2 viewportSize;
};
layout(binding = 1) uniform sampler2D oldSource;
layout(binding = 2) uniform sampler2D newSource;
void main() {
                        vec2 pixel = qt_TexCoord0 * viewportSize;
                        float radius = mix(maximumRadius * progress,
                            maximumRadius * (1.0 - progress), darkTarget);
                        float outside = smoothstep(radius - 1.5, radius + 1.5,
                            distance(pixel, origin));
                        float newMask = mix(1.0 - outside, outside, darkTarget);
                        vec4 oldColor = texture(oldSource, qt_TexCoord0);
                        vec4 newColor = texture(newSource, qt_TexCoord0);
                        oldColor += oldBackgroundColor * (1.0 - oldColor.a);
                        newColor += newBackgroundColor * (1.0 - newColor.a);
                        vec2 switchCenter = switchOrigin + switchSize * 0.5;
                        float switchRadius = switchSize.y * 0.5;
                        vec2 switchDistance = abs(pixel - switchCenter)
                            - (switchSize * 0.5 - vec2(switchRadius));
                        float switchEdge = length(max(switchDistance, vec2(0.0)))
                            + min(max(switchDistance.x, switchDistance.y), 0.0)
                            - switchRadius;
                        float insideSwitch = 1.0
                            - smoothstep(-1.0, 1.0, switchEdge);
                        fragColor = mix(oldColor, newColor, newMask)
                            * (1.0 - insideSwitch) * qt_Opacity;
                    }
