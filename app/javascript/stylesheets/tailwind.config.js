module.exports = {
  purge: [],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      //ブレイクポイント
      screens: {
        sm: '640px',
        md: '768px',
        lg: '1024px',
        xl: '1280px',
        '2x1': '15360px',
      },
      //ベースカラー
      colors: {
        dekiru: {
          main: '#FFFFFF',
          base: '#F8F8F8',
          blue: '#7373FF',
          light_blue: '#72FFFF',
          font: '#000000',
          keyword: '#595959',
          // gray: bg-gray-100,
          admin: '#FA198B',
        }
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
