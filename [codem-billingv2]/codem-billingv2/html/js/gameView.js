

export class GameView {
    constructor(canvas) {
        if (!canvas || !(canvas instanceof HTMLCanvasElement)) {
            throw new Error('Invalid canvas element');
        }
        this.canvas = canvas;
        this.gl = this.initGL();
        this.animationFrame = undefined;
        this.render = () => { };
        this.initialize();
    }

    initGL() {
        return this.canvas.getContext('webgl', {
            antialias: false,
            depth: false,
            stencil: false,
            alpha: false,
            desynchronized: true,
            failIfMajorPerformanceCaveat: false,
        });
    }

    createShader(type, src) {
        const shader = this.gl.createShader(type);
        this.gl.shaderSource(shader, src);
        this.gl.compileShader(shader);

        const infoLog = this.gl.getShaderInfoLog(shader);
        if (infoLog) {
            console.error(infoLog);
        }
        return shader;
    }

    createTexture() {
        const gl = this.gl;
        const tex = gl.createTexture();
        const texPixels = new Uint8Array([0, 0, 255, 255]);

        gl.bindTexture(gl.TEXTURE_2D, tex);
        gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, 1, 1, 0, gl.RGBA, gl.UNSIGNED_BYTE, texPixels);

        gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
        gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
        gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);

        gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
        gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.MIRRORED_REPEAT);
        gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.REPEAT);
        gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);

        return tex;
    }

    createBuffers() {
        const gl = this.gl;
        const vertexBuff = gl.createBuffer();
        gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuff);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([-1, -1, 1, -1, -1, 1, 1, 1]), gl.STATIC_DRAW);

        const texBuff = gl.createBuffer();
        gl.bindBuffer(gl.ARRAY_BUFFER, texBuff);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([0, 0, 1, 0, 0, 1, 1, 1]), gl.STATIC_DRAW);

        return { vertexBuff, texBuff };
    }

    createProgram() {
        const gl = this.gl;
        const vertexShaderSrc = `
            attribute vec2 a_position;
            attribute vec2 a_texcoord;
            uniform mat3 u_matrix;
            varying vec2 textureCoordinate;
            void main() {
                gl_Position = vec4(a_position, 0.0, 1.0);
                textureCoordinate = a_texcoord;
            }
        `;

        const fragmentShaderSrc = `
            varying highp vec2 textureCoordinate;
            uniform sampler2D external_texture;
            void main() {
                gl_FragColor = texture2D(external_texture, textureCoordinate);
            }
        `;

        const vertexShader = this.createShader(gl.VERTEX_SHADER, vertexShaderSrc);
        const fragmentShader = this.createShader(gl.FRAGMENT_SHADER, fragmentShaderSrc);

        const program = gl.createProgram();
        gl.attachShader(program, vertexShader);
        gl.attachShader(program, fragmentShader);
        gl.linkProgram(program);
        gl.useProgram(program);

        return {
            program,
            vloc: gl.getAttribLocation(program, 'a_position'),
            tloc: gl.getAttribLocation(program, 'a_texcoord')
        };
    }

    initialize() {
        const gl = this.gl;
        const tex = this.createTexture();
        const { program, vloc, tloc } = this.createProgram();
        const { vertexBuff, texBuff } = this.createBuffers();

        gl.useProgram(program);
        gl.bindTexture(gl.TEXTURE_2D, tex);
        gl.uniform1i(gl.getUniformLocation(program, 'external_texture'), 0);

        gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuff);
        gl.vertexAttribPointer(vloc, 2, gl.FLOAT, false, 0, 0);
        gl.enableVertexAttribArray(vloc);

        gl.bindBuffer(gl.ARRAY_BUFFER, texBuff);
        gl.vertexAttribPointer(tloc, 2, gl.FLOAT, false, 0, 0);
        gl.enableVertexAttribArray(tloc);

        gl.viewport(0, 0, gl.canvas.width, gl.canvas.height);

        this.startRendering();
    }

    startRendering() {
        this.render = () => {

            this.gl.drawArrays(this.gl.TRIANGLE_STRIP, 0, 4);
            this.gl.finish();

            this.animationFrame = requestAnimationFrame(() => this.render());
        };
        this.render();
    }

    resize(width, height) {
        this.gl.viewport(0, 0, width, height);
        this.canvas.width = width;
        this.canvas.height = height;
    }

    stop() {
        if (this.animationFrame) {
            cancelAnimationFrame(this.animationFrame);
            this.animationFrame = undefined;
        }
        if (this.gl) {
            this.gl.clear(this.gl.COLOR_BUFFER_BIT);
        }
    }

    destroy() {
        this.stop();
        this.gl = null;
        this.canvas = null;
    }
} 