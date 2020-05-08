const path = require("path");
const TerserPlugin = require("terser-webpack-plugin");
const config = {
  performance: { hints: false },
  mode: "production",
  entry: [path.resolve(__dirname, "src/index.tsx")],
  output: {
    filename: "javascripts/bundle.js",
    path: path.resolve(__dirname, "../app/assets")
  },
  module: {
    rules: [
      {
        test: /\.(ts|tsx)$/,
        use: ["ts-loader", "eslint-loader"]
      },
      {
        test: /\.(js|jsx)$/,
        use: ["source-map-loader"],
        exclude: /node_modules/,
        enforce: "pre"
      },
      {
        test: /\.(scss|css)$/,
        use: ["style-loader", "css-loader", "sass-loader"]
      },
      {
        test: /\.(jpg|png|svg|gif)$/,
        loaders: "url-loader"
      }
    ]
  },
  resolve: {
    symlinks: false,
    extensions: [".ts", ".js", ".tsx", ".scss", "css", ".svg", ".gif"],
    modules: ["node_modules"]
  },
  optimization: {
    minimizer: [
      new TerserPlugin({
        cache: true,
        parallel: true,
        sourceMap: true,
        terserOptions: {
          output: {
            comments: false,
            beautify: false
          }
        }
      })
    ],

    providedExports: true,
    usedExports: true,
    concatenateModules: true
  },
};
if (config.mode === "development") {
  config.devtool = "source-map";
}
module.exports = config;
