const webpack = require('webpack');
const path = require('path');
const BuildNotifierPlugin = require('webpack-build-notifier');
const ExtractCssChunks = require('extract-css-chunks-webpack-plugin');
const PnpPlugin = require(`pnp-webpack-plugin`);

const SASS_FUNCTIONS = {
  // Power function polyfill
  'math-pow($number, $exp)': (number, exp) => {
    const sass = require('sass');
    return new sass.types.Number(Math.pow(
      number.getValue(),
      exp.getValue()));
  },
};

module.exports = (env = {}, argv) => {
  const config = {
    mode: argv.mode === 'production' ? 'production' : 'development',
    context: path.resolve(__dirname),
    entry: {
<<<<<<< HEAD:tgui-next/packages/tgui/webpack.config.js
      tgui: [
        path.resolve(__dirname, './styles/main.scss'),
        path.resolve(__dirname, './styles/themes/cardtable.scss'),
        path.resolve(__dirname, './styles/themes/ntos.scss'),
        path.resolve(__dirname, './styles/themes/hackerman.scss'),
        path.resolve(__dirname, './styles/themes/retro.scss'),
        path.resolve(__dirname, './styles/themes/syndicate.scss'),
        path.resolve(__dirname, './index.js'),
=======
      'tgui': [
        './packages/tgui-polyfill',
        './packages/tgui',
      ],
      'tgui-panel': [
        './packages/tgui-polyfill',
        './packages/tgui-panel',
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d:tgui/webpack.config.js
      ],
    },
    output: {
      path: argv.useTmpFolder
        ? path.resolve(__dirname, './public/.tmp')
        : path.resolve(__dirname, './public'),
      filename: '[name].bundle.js',
      chunkFilename: '[name].chunk.js',
    },
    resolve: {
      extensions: ['.js', '.jsx'],
      alias: {},
      plugins: [
        PnpPlugin,
      ],
    },
    resolveLoader: {
      plugins: [
        PnpPlugin.moduleLoader(module),
      ],
    },
    module: {
      rules: [
        {
          test: /\.m?jsx?$/,
          use: [
            {
              loader: 'babel-loader',
              options: {
                presets: [
                  ['@babel/preset-env', {
                    modules: 'commonjs',
                    useBuiltIns: 'entry',
                    corejs: '3.6',
                    spec: false,
                    loose: true,
                    targets: {
                      ie: '8',
                    },
                  }],
                ],
                plugins: [
                  '@babel/plugin-transform-jscript',
                  'babel-plugin-inferno',
                  'babel-plugin-transform-remove-console',
                  'common/string.babel-plugin.cjs',
                ],
              },
            },
          ],
        },
        {
          test: /\.scss$/,
          use: [
            {
              loader: ExtractCssChunks.loader,
              options: {
                hot: argv.hot,
              },
            },
            {
              loader: 'css-loader',
              options: {},
            },
            {
              loader: 'sass-loader',
              options: {
                sassOptions: {
                  functions: SASS_FUNCTIONS,
                },
              },
            },
          ],
        },
        {
          test: /\.(png|jpg|svg)$/,
          use: [
            {
              loader: 'url-loader',
              options: {},
            },
          ],
        },
      ],
    },
    optimization: {
      noEmitOnErrors: true,
      splitChunks: {
        chunks: 'initial',
        name: 'tgui-common',
      },
    },
    performance: {
      hints: false,
    },
    devtool: false,
    plugins: [
      new webpack.EnvironmentPlugin({
        NODE_ENV: env.NODE_ENV || argv.mode || 'development',
        WEBPACK_HMR_ENABLED: env.WEBPACK_HMR_ENABLED || argv.hot || false,
        DEV_SERVER_IP: env.DEV_SERVER_IP || null,
      }),
      new ExtractCssChunks({
        filename: '[name].bundle.css',
        chunkFilename: '[name].chunk.css',
        orderWarning: true,
      }),
    ],
  };

  // Add a bundle analyzer to the plugins array
  if (argv.analyze) {
    const { BundleAnalyzerPlugin } = require('webpack-bundle-analyzer');
    config.plugins = [
      ...config.plugins,
      new BundleAnalyzerPlugin(),
    ];
  }

  // Production build specific options
  if (argv.mode === 'production') {
    const TerserPlugin = require('terser-webpack-plugin');
    const OptimizeCssAssetsPlugin = require('optimize-css-assets-webpack-plugin');
    config.optimization.minimizer = [
      new TerserPlugin({
        extractComments: false,
        terserOptions: {
          ie8: true,
          // mangle: false,
          output: {
            ascii_only: true,
            // beautify: true,
            // indent_level: 2,
          },
        },
      }),
    ];
    config.plugins = [
      ...config.plugins,
      new OptimizeCssAssetsPlugin({
        assetNameRegExp: /\.css$/g,
        cssProcessor: require('cssnano'),
        cssProcessorPluginOptions: {
          preset: ['default', {
            discardComments: {
              removeAll: true,
            },
          }],
        },
        canPrint: true,
      }),
    ];
  }

  // Development build specific options
  if (argv.mode !== 'production') {
    if (argv.hot) {
      config.plugins.push(new webpack.HotModuleReplacementPlugin());
    }
    config.devtool = 'cheap-module-source-map';
  }

  // Development server specific options
  if (argv.devServer) {
    config.plugins = [
      ...config.plugins,
      new BuildNotifierPlugin(),
    ];
    config.devServer = {
      // Informational flags
      progress: false,
      quiet: false,
      noInfo: false,
      // Fine-grained logging control
      clientLogLevel: 'silent',
      stats: {
        assets: false,
        builtAt: false,
        cached: false,
        children: false,
        chunks: false,
        colors: true,
        hash: false,
        timings: false,
        version: false,
        modules: false,
      },
    };
  }

  return config;
};
