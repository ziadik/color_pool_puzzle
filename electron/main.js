const { app, BrowserWindow, session } = require('electron');
const path = require('path');

// 👇 Опционально: отключаем аппаратное ускорение
// Раскомментируйте, если на старых видеокартах Windows 7 будет чёрный экран или артефакты
// app.disableHardwareAcceleration();

let mainWindow;

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1920,
    height: 1080,
    fullscreen: true,           // Запуск сразу на весь экран
    // kiosk: true,             // Раскомментируйте для строгого режима "киоска" (нельзя выйти через Alt+F4)
    autoHideMenuBar: true,      // Скрываем стандартное меню
    icon: path.join(__dirname, 'icon.ico'),
    backgroundColor: '#1a237e', // Цвет фона до загрузки Flutter (тёмно-синий, под вашу игру)
    show: false,                // Не показываем окно сразу, пока не загрузится
    webPreferences: {
      nodeIntegration: false,   // Безопасность: отключаем Node.js внутри Flutter
      contextIsolation: true,   // Безопасность: изолируем контексты
      webgl: true,              // WebGL для Flutter
      backgroundThrottling: false // Не приостанавливать анимации в фоне
    }
  });

  // 👇 БЛОКИРОВКА ВСЕХ ВНЕШНИХ ЗАПРОСОВ (дополнительная страховка)
  // Даже если Flutter случайно попытается обратиться к интернету, Electron перехватит запрос
  session.defaultSession.webRequest.onBeforeRequest(
    { urls: ['*://*.gstatic.com/*', '*://*.googleapis.com/*', '*://*.google.com/*'] },
    (details, callback) => {
      console.log('[BLOCKED]', details.url);
      callback({ cancel: true });
    }
  );

  // Загружаем локальный index.html из папки app
  mainWindow.loadFile(path.join(__dirname, 'app', 'index.html'));
    
  // Открываем DevTools для отладки (потом можно убрать)
  mainWindow.webContents.openDevTools();
  // Убираем стандартное меню Windows
  mainWindow.setMenu(null);

  // Показываем окно только когда Flutter полностью загрузился
  mainWindow.once('ready-to-show', () => {
    mainWindow.show();
  });

  // Обработка горячих клавиш
  mainWindow.webContents.on('before-input-event', (event, input) => {
    // F11 — переключение полноэкранного режима (для отладки)
    if (input.key === 'F11') {
      mainWindow.setFullScreen(!mainWindow.isFullScreen());
      event.preventDefault();
    }
    
    // F5 / Ctrl+R — блокируем обновление страницы (ломает роутинг Flutter)
    if (input.key === 'F5' || (input.control && input.key.toLowerCase() === 'r')) {
      event.preventDefault();
    }
    
    // F12 / Ctrl+Shift+I — DevTools (только для отладки, в финальной версии можно убрать)
    if (input.key === 'F12' || (input.control && input.shift && input.key.toLowerCase() === 'i')) {
      mainWindow.webContents.toggleDevTools();
      event.preventDefault();
    }
    
    // Ctrl+W / Alt+F4 — закрываем приложение корректно
    if ((input.control && input.key.toLowerCase() === 'w') || 
        (input.alt && input.key === 'F4')) {
      app.quit();
      event.preventDefault();
    }
  });

  // Обработка ошибок загрузки
  mainWindow.webContents.on('did-fail-load', (event, errorCode, errorDescription) => {
    console.error('[LOAD ERROR]', errorCode, errorDescription);
  });

  // Логирование сообщений из консоли Flutter (для отладки)
  mainWindow.webContents.on('console-message', (event, level, message, line, sourceId) => {
    console.log(`[FLUTTER] ${message}`);
  });

  // Очистка ссылки при закрытии
  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

// Запуск приложения
app.whenReady().then(() => {
  createWindow();

  // macOS: пересоздаём окно, если все закрыты
  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
  });
});

// Завершаем приложение, когда все окна закрыты (кроме macOS)
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit();
});

// Обработка необработанных ошибок (чтобы приложение не падало молча)
process.on('uncaughtException', (error) => {
  console.error('[UNCAUGHT EXCEPTION]', error);
});

process.on('unhandledRejection', (error) => {
  console.error('[UNHANDLED REJECTION]', error);
});