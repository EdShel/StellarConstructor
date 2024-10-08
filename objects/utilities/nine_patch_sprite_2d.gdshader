shader_type canvas_item;

uniform vec2 iResolution = vec2(192, 192);
uniform float padding = 64;

const int TILE = 1;
const int STRETCH = 2;
const int mode = TILE;

const float SCALE = 1.0;
const vec2 patchSize = vec2(192,192);

// Stolen with pride from https://github.com/fcouceiro/9-patch-frag-shader-android/tree/master
// Thanks, senpai!
vec4 chunk()
{
    return vec4(padding, padding, patchSize.x - padding, patchSize.y - padding);
}

vec4 fillChunk()
{
    return vec4(padding, padding, iResolution.x - padding, iResolution.y - padding);
}

vec2 patchTexture(vec2 coord)
{
	return coord;
}

vec2 fillTexture(vec2 coord)
{
    vec4 patchChunk = chunk();
    vec4 chunk = fillChunk();

    // 1
    if(coord.x < chunk.x && coord.y < chunk.y)
    {
        vec2 c = (coord - vec2(0.0, 0.0)) / (chunk.xy) * (patchChunk.xy) + vec2(0.0, 0.0);
        vec2 coordUv = c / patchSize;
        return patchTexture(coordUv);
    }
    // 2
    if(coord.x >= chunk.x && coord.x <= chunk.z && coord.y < chunk.y)
    {
        if (mode == STRETCH) {
            vec2 c = (coord - vec2(chunk.x, 0.0)) / vec2(chunk.z - chunk.x, chunk.y) * vec2(patchChunk.z - patchChunk.x, patchChunk.y) + vec2(patchChunk.x, 0.0);
            vec2 coordUv = c / patchSize;
            return patchTexture(coordUv);
        } else {
            vec2 c = (coord - vec2(chunk.x, 0.0)) / vec2(patchChunk.z - chunk.x, chunk.y) * vec2(patchChunk.z - patchChunk.x, patchChunk.y) + vec2(patchChunk.x, 0.0);
            int x = int(coord.x - chunk.x) % int(patchChunk.z - patchChunk.x);
            c.x = float(x) + patchChunk.x;
            vec2 coordUv = c / patchSize;
            return patchTexture(coordUv);
        }
    }
    // 3
    if(coord.x > chunk.z && coord.y < chunk.y)
    {
        vec2 c = (coord - vec2(chunk.z, 0.0)) / vec2(iResolution.x - chunk.z, chunk.y) * vec2(patchSize.x - patchChunk.z, patchChunk.y) + vec2(patchChunk.z, 0.0);
        vec2 coordUv = c / patchSize;
        return patchTexture(coordUv);
    }
    // 4
    if(coord.x < chunk.x && coord.y >= chunk.y && coord.y <= chunk.w)
    {
        if (mode == STRETCH) {
            vec2 c = (coord - vec2(0.0, chunk.y)) / vec2(chunk.x, chunk.w - chunk.y) * vec2(patchChunk.x, patchChunk.w - patchChunk.y) + vec2(0.0, patchChunk.y);
            vec2 coordUv = c / patchSize;
            return patchTexture(coordUv);
        } else {
            vec2 c = (coord - vec2(0.0, chunk.y)) / vec2(chunk.x, chunk.w - chunk.y) * vec2(patchChunk.x, patchChunk.w - patchChunk.y) + vec2(0.0, patchChunk.y);
            int y = int(coord.y - chunk.y) % int(patchChunk.w - patchChunk.y);
            c.y = float(y) + patchChunk.y;
            vec2 coordUv = c / patchSize;
            return patchTexture(coordUv);
        }
    }
    // 5
    if(coord.x >= chunk.x && coord.x <= chunk.z && coord.y >= chunk.y && coord.y <= chunk.w)
    {
        vec2 c = (coord - chunk.xy) / (chunk.zw - chunk.xy) * (patchChunk.zw - patchChunk.xy) + patchChunk.xy;
        vec2 coordUv = c / patchSize;
        return patchTexture(coordUv);
    }
    // 6
    if(coord.x > chunk.z && coord.y >= chunk.y && coord.y <= chunk.w)
    {
        if (mode == STRETCH) {
            vec2 c = (coord - chunk.zy) / vec2(iResolution.x - chunk.z, chunk.w - chunk.y) * vec2(patchSize.x - patchChunk.z, patchChunk.w - patchChunk.y) + patchChunk.zy;
            vec2 coordUv = c / patchSize;
            return patchTexture(coordUv);
        } else {
            vec2 c = (coord - chunk.zy) / vec2(iResolution.x - chunk.z, chunk.w - chunk.y) * vec2(patchSize.x - patchChunk.z, patchChunk.w - patchChunk.y) + patchChunk.zy;
            int y = int(coord.y - chunk.y) % int(patchChunk.w - patchChunk.y);
            c.y = float(y) + patchChunk.y;
            vec2 coordUv = c / patchSize;
            return patchTexture(coordUv);
        }
    }
    // 7
    if(coord.x < chunk.x && coord.y > chunk.w)
    {
        vec2 c = (coord - vec2(0.0, chunk.w)) / vec2(chunk.x, iResolution.y - chunk.w) * vec2(patchChunk.x, patchSize.y - patchChunk.w) + vec2(0.0, patchChunk.w);
        vec2 coordUv = c / patchSize;
        return patchTexture(coordUv);
    }
    // 8
    if(coord.x >= chunk.x && coord.x <= chunk.z && coord.y > chunk.w)
    {
        if (mode == STRETCH) {
            vec2 c = (coord - chunk.xw) / vec2(chunk.z - chunk.x, iResolution.y - chunk.w) * vec2(patchChunk.z - patchChunk.x, patchSize.y - patchChunk.w) + patchChunk.xw;
            vec2 coordUv = c / patchSize;
            return patchTexture(coordUv);
        } else {
            vec2 c = (coord - chunk.xw) / vec2(chunk.z - chunk.x, iResolution.y - chunk.w) * vec2(patchChunk.z - patchChunk.x, patchSize.y - patchChunk.w) + patchChunk.xw;
            int x = int(coord.x - chunk.x) % int(patchChunk.z - patchChunk.x);
            c.x = float(x) + patchChunk.x;
            vec2 coordUv = c / patchSize;
            return patchTexture(coordUv);
        }
    }
    // 9
    if(coord.x > chunk.z && coord.y > chunk.w)
    {
        vec2 c = (coord - chunk.zw) / (iResolution.xy - chunk.zw) * (patchSize - patchChunk.zw) + patchChunk.zw;
        vec2 coordUv = c / patchSize;
        return patchTexture(coordUv);
    }
}

void fragment() {

    COLOR = texture(TEXTURE, fillTexture(UV * iResolution));
}