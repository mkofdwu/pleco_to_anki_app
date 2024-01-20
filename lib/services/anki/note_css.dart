const ankiNoteCSS = r'''
* {
  padding: 0;
  margin: 0;
  box-sizing: border-box;
  font-family: Roboto;
}

.card {
  display: flex;
  flex-direction: column;
  row-gap: 12px;
  background-color: white;
  padding: 4px;
}

.chinese {
  font-family: 'Noto Sans';
}

h1 {
  font-weight: 600;
  font-size: 30px;
}

h2 {
  font-weight: 500;
  font-size: 16px;
  color: #000;
  opacity: 0.6;
  margin-bottom: 12px;
}

.tags {
  color: #000;
  opacity: 0.4;
  font-size: 12px;
  font-weight: 900;
  text-transform: uppercase;
  margin-top: 16px;
}

li {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.list-index {
  font-weight: bold;
}

.example {
  display: flex;
  color: rgb(90, 115, 180);
}

.bullet-point {
  min-width: 4px;
  max-width: 4px;
  border-radius: 3px;
  background-color: rgb(90, 115, 180);
  margin-top: 4px;
  margin-right: 10px;
}

.example-column {
  flex: 1 1 0%;
  display: flex;
  flex-direction: column;
  row-gap: 4px;
}

.example-column .chinese {
  font-weight: 500;
}

.example-column .pinyin {
  font-weight: 500;
  font-size: 12px;
}

.example-column .definition {
  opacity: 0.6;
  font-size: 12px;
}

.very-large {
  font-weight: 600;
  font-size: 64px;
}

.center {
  position: relative;
  text-align: center;
  width: 100%;
  top: 50%;
  transform: translateY(-50%);
}
''';
