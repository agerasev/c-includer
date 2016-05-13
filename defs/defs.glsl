#pragma omit
/* this custom pragma tells includer to omit the file */

/* this header allows C parsers use GLSL 1.30 sources properly */

// keywords

#define attribute
#define uniform
#define varying
#define centroid
#define flat
#define smooth
#define noperspective
#define in
#define out
#define inout
#define invariant
#define discard
#define lowp
#define mediump
#define highp
#define precision


// scalars

typedef unsigned int uint;


// vectors

/* built-in vector data types */
typedef struct vec2 vec2;
typedef struct vec3 vec3;
typedef struct vec4 vec4;
typedef struct ivec2 ivec2;
typedef struct ivec3 ivec3;
typedef struct ivec4 ivec4;
typedef struct uvec2 uvec2;
typedef struct uvec3 uvec3;
typedef struct uvec4 uvec4;
typedef struct bvec2 bvec2;
typedef struct bvec3 bvec3;
typedef struct bvec4 bvec4;


// matrices

typedef struct __mat2 mat2x2;
typedef struct __mat3 mat2x3;
typedef struct __mat4 mat2x4;
typedef struct __mat2 mat3x2;
typedef struct __mat3 mat3x3;
typedef struct __mat4 mat3x4;
typedef struct __mat2 mat4x2;
typedef struct __mat3 mat4x3;
typedef struct __mat4 mat4x4;
typedef mat2x2 mat2;
typedef mat3x3 mat3;
typedef mat4x4 mat4;

typedef struct {
	__mat();
	__mat(float);
	template <typename ... vtype>
	__mat(vtype ... vargs);
} __mat;

#define _MAT_TYPE(n) \
struct __mat##n { \
	vec##n operator [](int m); \
};

_MAT_TYPE(2)
_MAT_TYPE(3)
_MAT_TYPE(4)

// samplers

typedef __sampler sampler1D;
typedef __sampler sampler2D;
typedef __sampler sampler3D;
typedef __sampler samplerCube;
typedef __sampler sampler1DShadow;
typedef __sampler sampler2DShadow;
typedef __sampler samplerCubeShadow;
typedef __sampler sampler1DArray;
typedef __sampler sampler2DArray;
typedef __sampler sampler1DArrayShadow;
typedef __sampler sampler2DArrayShadow;
typedef __sampler isampler1D;
typedef __sampler isampler2D;
typedef __sampler isampler3D;
typedef __sampler isamplerCube;
typedef __sampler isampler1DArray;
typedef __sampler isampler2DArray;
typedef __sampler usampler1D;
typedef __sampler usampler2D;
typedef __sampler usampler3D;
typedef __sampler usamplerCube;
typedef __sampler usampler1DArray;
typedef __sampler usampler2DArray;

typedef struct {} __sampler;


// built-in variables

// vertex shader
out vec4  gl_Position;       // must be written to
out float gl_PointSize;      // may be written to
in  int   gl_VertexID;       
out float gl_ClipDistance[]; // may be written to
out vec4  gl_ClipVertex;     // may be written to, deprecated

// fragment shader
const int gl_MaxDrawBuffers;
in  vec4  gl_FragCoord;
in  bool  gl_FrontFacing;
in  float gl_ClipDistance[];
out vec4  gl_FragColor;                   // deprecated
out vec4  gl_FragData[gl_MaxDrawBuffers]; // deprecated
out float gl_FragDepth;
in  vec2  gl_PointCoord;

// built-in constants
const int gl_MaxTextureUnits = 16;
const int gl_MaxVertexAttribs = 16;
const int gl_MaxVertexUniformComponents = 1024;
const int gl_MaxVaryingFloats = 64;             // Deprecated
const int gl_MaxVaryingComponents = 64;
const int gl_MaxVertexTextureImageUnits = 16;
const int gl_MaxCombinedTextureImageUnits = 16;
const int gl_MaxTextureImageUnits = 16;
const int gl_MaxFragmentUniformComponents = 1024;
const int gl_MaxDrawBuffers = 8;
const int gl_MaxClipDistances = 8;

// built-in uniform states
struct gl_DepthRangeParameters {
	float near; // n
	float far;  // f
	float diff; // f - n
};
uniform gl_DepthRangeParameters gl_DepthRange;


// built-in functions
// angle and trigonometry functions
#define _TRI_FUNCS(genType) \
genType radians (genType degrees); \
genType degrees (genType radians); \
genType sin (genType angle); \
genType cos (genType angle); \
genType tan (genType angle); \
genType asin (genType x); \
genType acos (genType x); \
genType atan (genType y, genType x); \
genType atan (genType y_over_x); \
genType sinh (genType x); \
genType cosh (genType x); \
genType tanh (genType x); \
genType asinh (genType x); \
genType acosh (genType x); \
genType atanh (genType x);

// exponential functions
#define _EXP_FUNCS(genType) \
genType pow (genType x, genType y); \
genType exp (genType x); \
genType log (genType x); \
genType exp2 (genType x); \
genType log2 (genType x); \
genType sqrt (genType x); \
genType inversesqrt (genType x);

// common functions
#define _COMMON_FUNCS(genType, genIType, genUType, genBType) \
genType abs (genType x); \
genIType abs (genIType x); \
genType sign (genType x); \
genIType sign (genIType x); \
genType floor (genType x); \
genType trunc (genType x); \
genType round (genType x); \
genType roundEven (genType x); \
genType ceil (genType x); \
genType fract (genType x); \
genType mod (genType x, float y); \
genType mod (genType x, genType y); \
genType modf (genType x, out genType i); \
genType min (genType x, genType y); \
genType min (genType x, float y); \
genIType min (genIType x, genIType y); \
genIType min (genIType x, int y); \
genUType min (genUType x, genUType y); \
genUType min (genUType x, uint y); \
genType max (genType x, genType y); \
genType max (genType x, float y); \
genIType max (genIType x, genIType y); \
genIType max (genIType x, int y); \
genUType max (genUType x, genUType y); \
genUType max (genUType x, uint y); \
genType clamp (genType x, genType minVal, genType maxVal); \
genType clamp (genType x, float minVal, float maxVal); \
genIType clamp (genIType x, genIType minVal, genIType maxVal); \
genIType clamp (genIType x, int minVal, int maxVal); \
genUType clamp (genUType x, genUType minVal, genUType maxVal); \
genUType clamp (genUType x, uint minVal, uint maxVal); \
genType mix (genType x, genType y, genType a); \
genType mix (genType x, genType y, float a); \
genType mix (genType x, genType y, bvec a); \
genType step (genType edge, genType x); \
genType step (float edge, genType x); \
genType smoothstep (genType edge0, genType edge1, genType x); \
genType smoothstep (float edge0, float edge1, genType x); \
genBType isnan (genType x); \
genBType isinf (genType x);

// geomertric functions
#define _GEOM_FUNCS(genType) \
float length (genType x); \
float dot (genType x, genType y); \
genType normalize (genType x); \
genType faceforward(genType N, genType I, genType Nref); \
genType reflect (genType I, genType N); \
genType refract(genType I, genType N, float eta);

vec3 cross (vec3 x, vec3 y);
vec4 ftransform();

// matrix functions
#define _MAT_FUNCS(genType) \
mat matrixCompMult (mat x, mat y);

mat2 outerProduct(vec2 c, vec2 r);
mat3 outerProduct(vec3 c, vec3 r);
mat4 outerProduct(vec4 c, vec4 r);
mat2x3 outerProduct(vec3 c, vec2 r);
mat3x2 outerProduct(vec2 c, vec3 r);
mat2x4 outerProduct(vec4 c, vec2 r);
mat4x2 outerProduct(vec2 c, vec4 r);
mat3x4 outerProduct(vec4 c, vec3 r);
mat4x3 outerProduct(vec3 c, vec4 r);
mat2 transpose(mat2 m);
mat3 transpose(mat3 m);
mat4 transpose(mat4 m);
mat2x3 transpose(mat3x2 m);
mat3x2 transpose(mat2x3 m);
mat2x4 transpose(mat4x2 m);
mat4x2 transpose(mat2x4 m);
mat3x4 transpose(mat4x3 m);
mat4x3 transpose(mat3x4 m);

// vector realtional functions
#define _VECREL_FUNCS(genType, genIType, genUType, genBType) \
genBType lessThan(genType x, genType y); \
genBType lessThan(genIType x, genIType y); \
genBType lessThan(genUType x, genUType y); \
genBType lessThanEqual(genType x, genType y); \
genBType lessThanEqual(genIType x, genIType y); \
genBType lessThanEqual(genUType x, genUType y); \
genBType greaterThan(genType x, genType y); \
genBType greaterThan(genIType x, genIType y); \
genBType greaterThan(genUType x, genUType y); \
genBType greaterThanEqual(genType x, genType y); \
genBType greaterThanEqual(genIType x, genIType y); \
genBType greaterThanEqual(genUType x, genUType y); \
genBType equal(genType x, genType y); \
genBType equal(genIType x, genIType y); \
genBType equal(genUType x, genUType y); \
genBType equal(genBType x, genBType y); \
genBType notEqual(genType x, genType y); \
genBType notEqual(genIType x, genIType y); \
genBType notEqual(genUType x, genUType y); \
genBType notEqual(genBType x, genBType y); \
bool any(genBType x); \
bool all(genBType x); \
genBType not(genBType x); 

// texture lookup functions
#define _TEX_FUNCS(g) \
int textureSize (g##sampler1D sampler, int lod); \
ivec2 textureSize (g##sampler2D sampler, int lod); \
ivec3 textureSize (g##sampler3D sampler, int lod); \
ivec2 textureSize (g##samplerCube sampler, int lod); \
int textureSize (sampler1DShadow sampler, int lod); \
ivec2 textureSize (sampler2DShadow sampler, int lod); \
ivec2 textureSize (samplerCubeShadow sampler, int lod); \
ivec2 textureSize (g##sampler1DArray sampler, int lod); \
ivec3 textureSize (g##sampler2DArray sampler, int lod); \
ivec2 textureSize (sampler1DArrayShadow sampler, int lod); \
ivec3 textureSize (sampler2DArrayShadow sampler, int lod); \
g##vec4 texture (g##sampler1D sampler, float P, float bias = 0.0); \
g##vec4 texture (g##sampler2D sampler, vec2 P, float bias = 0.0); \
g##vec4 texture (g##sampler3D sampler, vec3 P, float bias = 0.0); \
g##vec4 texture (g##samplerCube sampler, vec3 P, float bias = 0.0); \
float texture (sampler1DShadow sampler, vec3 P, float bias = 0.0); \
float texture (sampler2DShadow sampler, vec3 P, float bias = 0.0); \
float texture (samplerCubeShadow sampler, vec4 P, float bias = 0.0); \
g##vec4 texture (g##sampler1DArray sampler, vec2 P, float bias = 0.0); \
g##vec4 texture (g##sampler2DArray sampler, vec3 P, float bias = 0.0); \
float texture (sampler1DArrayShadow sampler, vec3 P, float bias = 0.0); \
float texture (sampler2DArrayShadow sampler, vec4 P); \
g##vec4 textureProj (g##sampler1D sampler, vec2 P, float bias); \
g##vec4 textureProj (g##sampler1D sampler, vec4 P, float bias); \
g##vec4 textureProj (g##sampler2D sampler, vec3 P, float bias); \
g##vec4 textureProj (g##sampler2D sampler, vec4 P, float bias); \
g##vec4 textureProj (g##sampler3D sampler, vec4 P, float bias); \
float textureProj (sampler1DShadow sampler, vec4 P, float bias); \
float textureProj (sampler2DShadow sampler, vec4 P, float bias); \
g##vec4 textureLod (g##sampler1D sampler, float P, float lod); \
g##vec4 textureLod (g##sampler2D sampler, vec2 P, float lod); \
g##vec4 textureLod (g##sampler3D sampler, vec3 P, float lod); \
g##vec4 textureLod (g##samplerCube sampler, vec3 P, float lod); \
float textureLod (sampler1DShadow sampler, vec3 P, float lod); \
float textureLod (sampler2DShadow sampler, vec3 P, float lod); \
g##vec4 textureLod (g##sampler1DArray sampler, vec2 P, float lod); \
g##vec4 textureLod (g##sampler2DArray sampler, vec3 P, float lod); \
float textureLod (sampler1DArrayShadow sampler, vec3 P, float lod); \
g##vec4 textureOffset (g##sampler1D sampler, float P, int offset, float bias = 0.0); \
g##vec4 textureOffset (g##sampler2D sampler, vec2 P, ivec2 offset, float bias = 0.0); \
g##vec4 textureOffset (g##sampler3D sampler, vec3 P, ivec3 offset, float bias = 0.0); \
float textureOffset (sampler1DShadow sampler, vec3 P, int offset, float bias = 0.0); \
float textureOffset (sampler2DShadow sampler, vec3 P, ivec2 offset, float bias = 0.0); \
g##vec4 textureOffset (g##sampler1DArray sampler, vec2 P, int offset, float bias = 0.0); \
g##vec4 textureOffset (g##sampler2DArray sampler, vec3 P, ivec2 offset, float bias = 0.0); \
float textureOffset (sampler1DArrayShadow sampler, vec3 P, int offset, float bias = 0.0); \
g##vec4 texelFetch (g##sampler1D sampler, int P, int lod); \
g##vec4 texelFetch (g##sampler2D sampler, ivec2 P, int lod); \
g##vec4 texelFetch (g##sampler3D sampler, ivec3 P, int lod); \
g##vec4 texelFetch (g##sampler1DArray sampler, ivec2 P, int lod); \
g##vec4 texelFetch (g##sampler2DArray sampler, ivec3 P, int lod); \
g##vec4 texelFetchOffset (g##sampler1D sampler, int P, int lod, int offset); \
g##vec4 texelFetchOffset (g##sampler2D sampler, ivec2 P, int lod, ivec2 offset); \
g##vec4 texelFetchOffset (g##sampler3D sampler, ivec3 P, int lod, ivec3 offset); \
g##vec4 texelFetchOffset (g##sampler1DArray sampler, ivec2 P, int lod, int offset); \
g##vec4 texelFetchOffset (g##sampler2DArray sampler, ivec3 P, int lod, ivec2 offset); \
g##vec4 textureProjOffset (g##sampler1D sampler, vec2 P, int offset, float bias = 0.0); \
g##vec4 textureProjOffset (g##sampler1D sampler, vec4 P, int offset, float bias = 0.0); \
g##vec4 textureProjOffset (g##sampler2D sampler, vec3 P, ivec2 offset, float bias = 0.0); \
g##vec4 textureProjOffset (g##sampler2D sampler, vec4 P, ivec2 offset, float bias = 0.0); \
g##vec4 textureProjOffset (g##sampler3D sampler, vec4 P, ivec3 offset, float bias = 0.0); \
float textureProjOffset (sampler1DShadow sampler, vec4 P, int offset, float bias = 0.0); \
float textureProjOffset (sampler2DShadow sampler, vec4 P, ivec2 offset, float bias = 0.0); \
g##vec4 textureLodOffset (g##sampler1D sampler, float P, float lod, int offset); \
g##vec4 textureLodOffset (g##sampler2D sampler, vec2 P, float lod, ivec2 offset); \
g##vec4 textureLodOffset (g##sampler3D sampler, vec3 P, float lod, ivec3 offset); \
float textureLodOffset (sampler1DShadow sampler, vec3 P, float lod, int offset); \
float textureLodOffset (sampler2DShadow sampler, vec3 P, float lod, ivec2 offset); \
g##vec4 textureLodOffset (g##sampler1DArray sampler, vec2 P, float lod, int offset); \
g##vec4 textureLodOffset (g##sampler2DArray sampler, vec3 P, float lod, ivec2 offset); \
float textureLodOffset (sampler1DArrayShadow sampler, vec3 P, float lod, int offset); \
g##vec4 textureProjLod (g##sampler1D sampler, vec2 P, float lod); \
g##vec4 textureProjLod (g##sampler1D sampler, vec4 P, float lod); \
g##vec4 textureProjLod (g##sampler2D sampler, vec3 P, float lod); \
g##vec4 textureProjLod (g##sampler2D sampler, vec4 P, float lod); \
g##vec4 textureProjLod (g##sampler3D sampler, vec4 P, float lod); \
float textureProjLod (sampler1DShadow sampler, vec4 P, float lod); \
float textureProjLod (sampler2DShadow sampler, vec4 P, float lod); \
g##vec4 textureProjLodOffset (g##sampler1D sampler, vec2 P, float lod, int offset); \
g##vec4 textureProjLodOffset (g##sampler1D sampler, vec4 P, float lod, int offset); \
g##vec4 textureProjLodOffset (g##sampler2D sampler, vec3 P, float lod, ivec2 offset); \
g##vec4 textureProjLodOffset (g##sampler2D sampler, vec4 P, float lod, ivec2 offset); \
g##vec4 textureProjLodOffset (g##sampler3D sampler, vec4 P, float lod, ivec3 offset); \
float textureProjLodOffset (sampler1DShadow sampler, vec4 P, float lod, int offset); \
float textureProjLodOffset (sampler2DShadow sampler, vec4 P, float lod, ivec2 offset); \
g##vec4 textureGrad (g##sampler1D sampler, float P, float dPdx, float dPdy); \
g##vec4 textureGrad (g##sampler2D sampler, vec2 P, vec2 dPdx, vec2 dPdy); \
g##vec4 textureGrad (g##sampler3D sampler, vec3 P, vec3 dPdx, vec3 dPdy); \
g##vec4 textureGrad (g##samplerCube sampler, vec3 P, vec3 dPdx, vec3 dPdy); \
float textureGrad (sampler1DShadow sampler, vec3 P, float dPdx, float dPdy); \
float textureGrad (sampler2DShadow sampler, vec3 P, vec2 dPdx, vec2 dPdy); \
float textureGrad (samplerCubeShadow sampler, vec4 P, vec3 dPdx, vec3 dPdy); \
g##vec4 textureGrad (g##sampler1DArray sampler, vec2 P, float dPdx, float dPdy); \
g##vec4 textureGrad (g##sampler2DArray sampler, vec3 P, vec2 dPdx, vec2 dPdy); \
float textureGrad (sampler1DArrayShadow sampler, vec3 P, float dPdx, float dPdy); \
float textureGrad (sampler2DArrayShadow sampler, vec4 P, vec2 dPdx, vec2 dPdy); \
g##vec4 textureGradOffset (g##sampler1D sampler, float P, float dPdx, float dPdy, int offset); \
g##vec4 textureGradOffset (g##sampler2D sampler, vec2 P, vec2 dPdx, vec2 dPdy, ivec2 offset); \
g##vec4 textureGradOffset (g##sampler3D sampler, vec3 P, vec3 dPdx, vec3 dPdy, ivec3 offset); \
float textureGradOffset (sampler1DShadow sampler, vec3 P, float dPdx, float dPdy, int offset ); \
float textureGradOffset (sampler2DShadow sampler, vec3 P, vec2 dPdx, vec2 dPdy, ivec2 offset); \
g##vec4 textureGradOffset (g##sampler1DArray sampler, vec2 P, float dPdx, float dPdy, int offset); \
g##vec4 textureGradOffset (g##sampler2DArray sampler, vec3 P, vec2 dPdx, vec2 dPdy, ivec2 offset); \
float textureGradOffset (sampler1DArrayShadow sampler, vec3 P, float dPdx, float dPdy, int offset); \
float textureGradOffset (sampler2DArrayShadow sampler, vec4 P, vec2 dPdx, vec2 dPdy, ivec2 offset); \
g##vec4 textureProjGrad (g##sampler1D sampler, vec2 P, float dPdx, float dPdy); \
g##vec4 textureProjGrad (g##sampler1D sampler, vec4 P, float dPdx, float dPdy); \
g##vec4 textureProjGrad (g##sampler2D sampler, vec3 P, vec2 dPdx, vec2 dPdy); \
g##vec4 textureProjGrad (g##sampler2D sampler, vec4 P, vec2 dPdx, vec2 dPdy); \
g##vec4 textureProjGrad (g##sampler3D sampler, vec4 P, vec3 dPdx, vec3 dPdy); \
float textureProjGrad (sampler1DShadow sampler, vec4 P, float dPdx, float dPdy); \
float textureProjGrad (sampler2DShadow sampler, vec4 P, vec2 dPdx, vec2 dPdy); \
g##vec4 textureProjGradOffset (g##sampler1D sampler, vec2 P, float dPdx, float dPdy, int offset); \
g##vec4 textureProjGradOffset (g##sampler1D sampler, vec4 P, float dPdx, float dPdy, int offset); \
g##vec4 textureProjGradOffset (g##sampler2D sampler, vec3 P, vec2 dPdx, vec2 dPdy, vec2 offset); \
g##vec4 textureProjGradOffset (g##sampler2D sampler, vec4 P, vec2 dPdx, vec2 dPdy, vec2 offset); \
g##vec4 textureProjGradOffset (g##sampler3D sampler, vec4 P, vec3 dPdx, vec3 dPdy, vec3 offset); \
float textureProjGradOffset (sampler1DShadow sampler, vec4 P, float dPdx, float dPdy, int offset); \
float textureProjGradOffset (sampler2DShadow sampler, vec4 P, vec2 dPdx, vec2 dPdy, vec2 offset);

// fragment processing functions
#define _FRAG_FUNCS(genType) \
genType dFdx (genType p); \
genType dFdy (genType p); \
genType fwidth (genType p);

// noise functions
#define _NOISE_FUNCS(genType) \
float noise1 (genType x); \
vec2 noise2 (genType x); \
vec3 noise3 (genType x); \
vec4 noise4 (genType x);


// generate functions
#define _GEN_DIM_FUNCS(genType, genIType, genUType, genBType) \
_TRI_FUNCS(genType); \
_EXP_FUNCS(genType); \
_COMMON_FUNCS(genType, genIType, genUType, genBType); \
_GEOM_FUNCS(genType); \
_MAT_FUNCS(genType); \
_VECREL_FUNCS(genType, genIType, genUType, genBType); \
_FRAG_FUNCS(genType); \
_NOISE_FUNCS(genType);

_GEN_DIM_FUNCS(float, int, uint, bool)
_GEN_DIM_FUNCS(vec2, ivec2, uvec2, bvec2)
_GEN_DIM_FUNCS(vec3, ivec3, uvec3, bvec3)
_GEN_DIM_FUNCS(vec4, ivec4, uvec4, bvec4)

_TEX_FUNCS()
_TEX_FUNCS(i)
_TEX_FUNCS(u)


// reserved words

#define common
#define partition
#define active
#define packed
#define noinline
#define external
#define interface
#define half
#define fixed
#define superp
#define input
#define output
#define hvec2
#define hvec3
#define hvec4
#define dvec2
#define dvec3
#define dvec4
#define fvec2
#define fvec3
#define fvec4
#define sampler2DRect
#define sampler3DRect
#define sampler2DRectShadow
#define samplerBuffer
#define filter
#define image1D
#define image2D
#define image3D
#define imageCube
#define iimage1D
#define iimage2D
#define iimage3D
#define iimageCube
#define uimage1D
#define uimage2D
#define uimage3D
#define uimageCube
#define image1DArray
#define image2DArray
#define iimage1DArray
#define iimage2DArray
#define uimage1DArray
#define uimage2DArray
#define image1DShadow
#define image2DShadow
#define image1DArrayShadow
#define image2DArrayShadow
#define imageBuffer
#define iimageBuffer
#define uimageBuffer
#define cast
#define row_major


// vector generators
#define _VEC_TYPE_BASE(pref, type) \
typedef struct { \
	type operator [](int); \
} __##pref##_base;

#define _VEC_TYPE_2(pref, type) \
struct pref##2 : public __##pref##_base { \
	pref##2(); \
	pref##2(type); \
	pref##2(type, type); \
	pref##2(pref##2); \
	type x,y; \
	pref##2 xx,xy,yx,yy; \
	pref##3 xxx,xxy,xyx,xyy,yxx,yxy,yyx,yyy; \
	pref##4 xxxx,xxxy,xxyx,xxyy,xyxx,xyxy,xyyx,xyyy, \
	        yxxx,yxxy,yxyx,yxyy,yyxx,yyxy,yyyx,yyyy; \
	pref r,g; \
	pref##2 rr,rg,gr,gg; \
	pref##3 rrr,rrg,rgr,rgg,grr,grg,ggr,ggg; \
	pref##4 rrrr,rrrg,rrgr,rrgg,rgrr,rgrg,rggr,rggg, \
	        grrr,grrg,grgr,grgg,ggrr,ggrg,gggr,gggg; \
	type s,t; \
	pref##2 ss,st,ts,tt; \
	pref##3 sss,sst,sts,stt,tss,tst,tts,ttt; \
	pref##4 ssss,ssst,ssts,sstt,stss,stst,stts,sttt, \
	        tsss,tsst,tsts,tstt,ttss,ttst,ttts,tttt; \
};

#define _VEC_TYPE_3(pref, type) \
struct pref##3 : public __##pref##_base { \
	pref##3(); \
	pref##3(type); \
	pref##3(type, type, type); \
	pref##3(pref##2, type); \
	pref##3(type, pref##2); \
	pref##3(pref##3); \
	type x,y,z; \
	pref##2 xx,xy,xz,yx,yy,yz,zx,zy,zz; \
	pref##3 xxx,xxy,xxz,xyx,xyy,xyz,xzx,xzy,xzz, \
	        yxx,yxy,yxz,yyx,yyy,yyz,yzx,yzy,yzz, \
	        zxx,zxy,zxz,zyx,zyy,zyz,zzx,zzy,zzz; \
	pref##4 xxxx,xxxy,xxxz,xxyx,xxyy,xxyz,xxzx,xxzy,xxzz, \
	        xyxx,xyxy,xyxz,xyyx,xyyy,xyyz,xyzx,xyzy,xyzz, \
	        xzxx,xzxy,xzxz,xzyx,xzyy,xzyz,xzzx,xzzy,xzzz, \
	        yxxx,yxxy,yxxz,yxyx,yxyy,yxyz,yxzx,yxzy,yxzz, \
	        yyxx,yyxy,yyxz,yyyx,yyyy,yyyz,yyzx,yyzy,yyzz, \
	        yzxx,yzxy,yzxz,yzyx,yzyy,yzyz,yzzx,yzzy,yzzz, \
	        zxxx,zxxy,zxxz,zxyx,zxyy,zxyz,zxzx,zxzy,zxzz, \
	        zyxx,zyxy,zyxz,zyyx,zyyy,zyyz,zyzx,zyzy,zyzz, \
	        zzxx,zzxy,zzxz,zzyx,zzyy,zzyz,zzzx,zzzy,zzzz; \
	pref r,g,b; \
	pref##2 rr,rg,rb,gr,gg,gb,br,bg,bb; \
	pref##3 rrr,rrg,rrb,rgr,rgg,rgb,rbr,rbg,rbb, \
	        grr,grg,grb,ggr,ggg,ggb,gbr,gbg,gbb, \
	        brr,brg,brb,bgr,bgg,bgb,bbr,bbg,bbb; \
	pref##4 rrrr,rrrg,rrrb,rrgr,rrgg,rrgb,rrbr,rrbg,rrbb, \
	        rgrr,rgrg,rgrb,rggr,rggg,rggb,rgbr,rgbg,rgbb, \
	        rbrr,rbrg,rbrb,rbgr,rbgg,rbgb,rbbr,rbbg,rbbb, \
	        grrr,grrg,grrb,grgr,grgg,grgb,grbr,grbg,grbb, \
	        ggrr,ggrg,ggrb,gggr,gggg,gggb,ggbr,ggbg,ggbb, \
	        gbrr,gbrg,gbrb,gbgr,gbgg,gbgb,gbbr,gbbg,gbbb, \
	        brrr,brrg,brrb,brgr,brgg,brgb,brbr,brbg,brbb, \
	        bgrr,bgrg,bgrb,bggr,bggg,bggb,bgbr,bgbg,bgbb, \
	        bbrr,bbrg,bbrb,bbgr,bbgg,bbgb,bbbr,bbbg,bbbb; \
	pref s,t,p; \
	pref##2 ss,st,sp,ts,tt,tp,ps,pt,pp; \
	pref##3 sss,sst,ssp,sts,stt,stp,sps,spt,spp, \
	        tss,tst,tsp,tts,ttt,ttp,tps,tpt,tpp, \
	        pss,pst,psp,pts,ptt,ptp,pps,ppt,ppp; \
	pref##4 ssss,ssst,sssp,ssts,sstt,sstp,ssps,sspt,sspp, \
	        stss,stst,stsp,stts,sttt,sttp,stps,stpt,stpp, \
	        spss,spst,spsp,spts,sptt,sptp,spps,sppt,sppp, \
	        tsss,tsst,tssp,tsts,tstt,tstp,tsps,tspt,tspp, \
	        ttss,ttst,ttsp,ttts,tttt,tttp,ttps,ttpt,ttpp, \
	        tpss,tpst,tpsp,tpts,tptt,tptp,tpps,tppt,tppp, \
	        psss,psst,pssp,psts,pstt,pstp,psps,pspt,pspp, \
	        ptss,ptst,ptsp,ptts,pttt,pttp,ptps,ptpt,ptpp, \
	        ppss,ppst,ppsp,ppts,pptt,pptp,ppps,pppt,pppp; \
};

#define _VEC_TYPE_4(pref, type) \
struct pref##4 : public __##pref##_base {  \
	pref##4(); \
	pref##4(type); \
	pref##4(type, type, type, type); \
	pref##4(pref##2, type, type); \
	pref##4(type, pref##2, type); \
	pref##4(type, type, pref##2); \
	pref##4(pref##3, type); \
	pref##4(type, pref##3); \
	pref##4(pref##4); \
	type x,y,z,w; \
	pref##2 xx,xy,xz,xw,yx,yy,yz,yw,zx,zy,zz,zw,wx,wy,wz,ww; \
	pref##3 xxx,xxy,xxz,xxw,xyx,xyy,xyz,xyw,xzx,xzy,xzz,xzw,xwx,xwy,xwz,xww, \
	        yxx,yxy,yxz,yxw,yyx,yyy,yyz,yyw,yzx,yzy,yzz,yzw,ywx,ywy,ywz,yww, \
	        zxx,zxy,zxz,zxw,zyx,zyy,zyz,zyw,zzx,zzy,zzz,zzw,zwx,zwy,zwz,zww, \
	        wxx,wxy,wxz,wxw,wyx,wyy,wyz,wyw,wzx,wzy,wzz,wzw,wwx,wwy,wwz,www; \
	pref##4 xxxx,xxxy,xxxz,xxxw,xxyx,xxyy,xxyz,xxyw,xxzx,xxzy,xxzz,xxzw,xxwx,xxwy,xxwz,xxww, \
	        xyxx,xyxy,xyxz,xyxw,xyyx,xyyy,xyyz,xyyw,xyzx,xyzy,xyzz,xyzw,xywx,xywy,xywz,xyww, \
	        xzxx,xzxy,xzxz,xzxw,xzyx,xzyy,xzyz,xzyw,xzzx,xzzy,xzzz,xzzw,xzwx,xzwy,xzwz,xzww, \
	        xwxx,xwxy,xwxz,xwxw,xwyx,xwyy,xwyz,xwyw,xwzx,xwzy,xwzz,xwzw,xwwx,xwwy,xwwz,xwww, \
	        yxxx,yxxy,yxxz,yxxw,yxyx,yxyy,yxyz,yxyw,yxzx,yxzy,yxzz,yxzw,yxwx,yxwy,yxwz,yxww, \
	        yyxx,yyxy,yyxz,yyxw,yyyx,yyyy,yyyz,yyyw,yyzx,yyzy,yyzz,yyzw,yywx,yywy,yywz,yyww, \
	        yzxx,yzxy,yzxz,yzxw,yzyx,yzyy,yzyz,yzyw,yzzx,yzzy,yzzz,yzzw,yzwx,yzwy,yzwz,yzww, \
	        ywxx,ywxy,ywxz,ywxw,ywyx,ywyy,ywyz,ywyw,ywzx,ywzy,ywzz,ywzw,ywwx,ywwy,ywwz,ywww, \
	        zxxx,zxxy,zxxz,zxxw,zxyx,zxyy,zxyz,zxyw,zxzx,zxzy,zxzz,zxzw,zxwx,zxwy,zxwz,zxww, \
	        zyxx,zyxy,zyxz,zyxw,zyyx,zyyy,zyyz,zyyw,zyzx,zyzy,zyzz,zyzw,zywx,zywy,zywz,zyww, \
	        zzxx,zzxy,zzxz,zzxw,zzyx,zzyy,zzyz,zzyw,zzzx,zzzy,zzzz,zzzw,zzwx,zzwy,zzwz,zzww, \
	        zwxx,zwxy,zwxz,zwxw,zwyx,zwyy,zwyz,zwyw,zwzx,zwzy,zwzz,zwzw,zwwx,zwwy,zwwz,zwww, \
	        wxxx,wxxy,wxxz,wxxw,wxyx,wxyy,wxyz,wxyw,wxzx,wxzy,wxzz,wxzw,wxwx,wxwy,wxwz,wxww, \
	        wyxx,wyxy,wyxz,wyxw,wyyx,wyyy,wyyz,wyyw,wyzx,wyzy,wyzz,wyzw,wywx,wywy,wywz,wyww, \
	        wzxx,wzxy,wzxz,wzxw,wzyx,wzyy,wzyz,wzyw,wzzx,wzzy,wzzz,wzzw,wzwx,wzwy,wzwz,wzww, \
	        wwxx,wwxy,wwxz,wwxw,wwyx,wwyy,wwyz,wwyw,wwzx,wwzy,wwzz,wwzw,wwwx,wwwy,wwwz,wwww; \
	type r,g,b,a; \
	pref##2 rr,rg,rb,ra,gr,gg,gb,ga,br,bg,bb,ba,ar,ag,ab,aa; \
	pref##3 rrr,rrg,rrb,rra,rgr,rgg,rgb,rga,rbr,rbg,rbb,rba,rar,rag,rab,raa, \
	        grr,grg,grb,gra,ggr,ggg,ggb,gga,gbr,gbg,gbb,gba,gar,gag,gab,gaa, \
	        brr,brg,brb,bra,bgr,bgg,bgb,bga,bbr,bbg,bbb,bba,bar,bag,bab,baa, \
	        arr,arg,arb,ara,agr,agg,agb,aga,abr,abg,abb,aba,aar,aag,aab,aaa; \
	pref##4 rrrr,rrrg,rrrb,rrra,rrgr,rrgg,rrgb,rrga,rrbr,rrbg,rrbb,rrba,rrar,rrag,rrab,rraa, \
	        rgrr,rgrg,rgrb,rgra,rggr,rggg,rggb,rgga,rgbr,rgbg,rgbb,rgba,rgar,rgag,rgab,rgaa, \
	        rbrr,rbrg,rbrb,rbra,rbgr,rbgg,rbgb,rbga,rbbr,rbbg,rbbb,rbba,rbar,rbag,rbab,rbaa, \
	        rarr,rarg,rarb,rara,ragr,ragg,ragb,raga,rabr,rabg,rabb,raba,raar,raag,raab,raaa, \
	        grrr,grrg,grrb,grra,grgr,grgg,grgb,grga,grbr,grbg,grbb,grba,grar,grag,grab,graa, \
	        ggrr,ggrg,ggrb,ggra,gggr,gggg,gggb,ggga,ggbr,ggbg,ggbb,ggba,ggar,ggag,ggab,ggaa, \
	        gbrr,gbrg,gbrb,gbra,gbgr,gbgg,gbgb,gbga,gbbr,gbbg,gbbb,gbba,gbar,gbag,gbab,gbaa, \
	        garr,garg,garb,gara,gagr,gagg,gagb,gaga,gabr,gabg,gabb,gaba,gaar,gaag,gaab,gaaa, \
	        brrr,brrg,brrb,brra,brgr,brgg,brgb,brga,brbr,brbg,brbb,brba,brar,brag,brab,braa, \
	        bgrr,bgrg,bgrb,bgra,bggr,bggg,bggb,bgga,bgbr,bgbg,bgbb,bgba,bgar,bgag,bgab,bgaa, \
	        bbrr,bbrg,bbrb,bbra,bbgr,bbgg,bbgb,bbga,bbbr,bbbg,bbbb,bbba,bbar,bbag,bbab,bbaa, \
	        barr,barg,barb,bara,bagr,bagg,bagb,baga,babr,babg,babb,baba,baar,baag,baab,baaa, \
	        arrr,arrg,arrb,arra,argr,argg,argb,arga,arbr,arbg,arbb,arba,arar,arag,arab,araa, \
	        agrr,agrg,agrb,agra,aggr,aggg,aggb,agga,agbr,agbg,agbb,agba,agar,agag,agab,agaa, \
	        abrr,abrg,abrb,abra,abgr,abgg,abgb,abga,abbr,abbg,abbb,abba,abar,abag,abab,abaa, \
	        aarr,aarg,aarb,aara,aagr,aagg,aagb,aaga,aabr,aabg,aabb,aaba,aaar,aaag,aaab,aaaa; \
	type s,t,p,q; \
	pref##2 ss,st,sp,sq,ts,tt,tp,tq,ps,pt,pp,pq,qs,qt,qp,qq; \
	pref##3 sss,sst,ssp,ssq,sts,stt,stp,stq,sps,spt,spp,spq,sqs,sqt,sqp,sqq, \
	        tss,tst,tsp,tsq,tts,ttt,ttp,ttq,tps,tpt,tpp,tpq,tqs,tqt,tqp,tqq, \
	        pss,pst,psp,psq,pts,ptt,ptp,ptq,pps,ppt,ppp,ppq,pqs,pqt,pqp,pqq, \
	        qss,qst,qsp,qsq,qts,qtt,qtp,qtq,qps,qpt,qpp,qpq,qqs,qqt,qqp,qqq; \
	pref##4 ssss,ssst,sssp,sssq,ssts,sstt,sstp,sstq,ssps,sspt,sspp,sspq,ssqs,ssqt,ssqp,ssqq, \
	        stss,stst,stsp,stsq,stts,sttt,sttp,sttq,stps,stpt,stpp,stpq,stqs,stqt,stqp,stqq, \
	        spss,spst,spsp,spsq,spts,sptt,sptp,sptq,spps,sppt,sppp,sppq,spqs,spqt,spqp,spqq, \
	        sqss,sqst,sqsp,sqsq,sqts,sqtt,sqtp,sqtq,sqps,sqpt,sqpp,sqpq,sqqs,sqqt,sqqp,sqqq, \
	        tsss,tsst,tssp,tssq,tsts,tstt,tstp,tstq,tsps,tspt,tspp,tspq,tsqs,tsqt,tsqp,tsqq, \
	        ttss,ttst,ttsp,ttsq,ttts,tttt,tttp,tttq,ttps,ttpt,ttpp,ttpq,ttqs,ttqt,ttqp,ttqq, \
	        tpss,tpst,tpsp,tpsq,tpts,tptt,tptp,tptq,tpps,tppt,tppp,tppq,tpqs,tpqt,tpqp,tpqq, \
	        tqss,tqst,tqsp,tqsq,tqts,tqtt,tqtp,tqtq,tqps,tqpt,tqpp,tqpq,tqqs,tqqt,tqqp,tqqq, \
	        psss,psst,pssp,pssq,psts,pstt,pstp,pstq,psps,pspt,pspp,pspq,psqs,psqt,psqp,psqq, \
	        ptss,ptst,ptsp,ptsq,ptts,pttt,pttp,pttq,ptps,ptpt,ptpp,ptpq,ptqs,ptqt,ptqp,ptqq, \
	        ppss,ppst,ppsp,ppsq,ppts,pptt,pptp,pptq,ppps,pppt,pppp,pppq,ppqs,ppqt,ppqp,ppqq, \
	        pqss,pqst,pqsp,pqsq,pqts,pqtt,pqtp,pqtq,pqps,pqpt,pqpp,pqpq,pqqs,pqqt,pqqp,pqqq, \
	        qsss,qsst,qssp,qssq,qsts,qstt,qstp,qstq,qsps,qspt,qspp,qspq,qsqs,qsqt,qsqp,qsqq, \
	        qtss,qtst,qtsp,qtsq,qtts,qttt,qttp,qttq,qtps,qtpt,qtpp,qtpq,qtqs,qtqt,qtqp,qtqq, \
	        qpss,qpst,qpsp,qpsq,qpts,qptt,qptp,qptq,qpps,qppt,qppp,qppq,qpqs,qpqt,qpqp,qpqq, \
	        qqss,qqst,qqsp,qqsq,qqts,qqtt,qqtp,qqtq,qqps,qqpt,qqpp,qqpq,qqqs,qqqt,qqqp,qqqq; \
};

#define _VEC_TYPES(pref, type) \
_VEC_TYPE_2(pref, type) \
_VEC_TYPE_3(pref, type) \
_VEC_TYPE_4(pref, type)

_VEC_TYPES(vec, float)
_VEC_TYPES(ivec, int)
_VEC_TYPES(uvec, uint)
_VEC_TYPES(bvec, bool)
