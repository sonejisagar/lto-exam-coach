import os
import subprocess
from PIL import Image

OUT_DIR = os.path.abspath(os.path.join('play_store_screenshots', 'tablet'))
os.makedirs(OUT_DIR, exist_ok=True)
CHROME_PATH = r'C:\Program Files\Google\Chrome\Application\chrome.exe'

def get_tablet_base_css():
    return """
    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
    }
    body {
        width: 1600px;
        height: 2560px;
        overflow: hidden;
        background: #F8FAFC;
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Inter', Helvetica, Arial, sans-serif;
        color: #0F172A;
        position: relative;
        display: flex;
        flex-direction: column;
        align-items: center;
    }
    
    /* Background Ambience */
    .bg-gradient {
        position: absolute;
        top: 0;
        left: 0;
        width: 1600px;
        height: 2560px;
        background: radial-gradient(circle at 85% 15%, rgba(207, 250, 254, 0.6) 0%, rgba(248, 250, 252, 0.4) 50%, rgba(241, 245, 249, 1) 100%);
        pointer-events: none;
        z-index: 1;
    }
    
    .bg-roads {
        position: absolute;
        top: 0;
        left: 0;
        width: 1600px;
        height: 2560px;
        pointer-events: none;
        z-index: 2;
    }
    
    /* Header Area */
    .header-area {
        position: relative;
        z-index: 10;
        width: 100%;
        padding: 60px 60px 18px 60px;
        display: flex;
        flex-direction: column;
        align-items: center;
        text-align: center;
    }
    
    .headline {
        font-size: 74px;
        font-weight: 900;
        color: #0F172A;
        line-height: 1.15;
        letter-spacing: -1.2px;
    }
    
    .headline span.blue {
        color: #0284C7;
    }
    
    .subtext {
        font-size: 34px;
        font-weight: 600;
        color: #0284C7;
        margin-top: 10px;
        line-height: 1.3;
    }
    
    /* 10-Inch Tablet Mockup Frame */
    .tablet-frame {
        position: relative;
        z-index: 10;
        width: 1380px;
        height: 2000px;
        margin-top: 6px;
        background: #FFFFFF;
        border: 22px solid #FFFFFF;
        outline: 2.5px solid #E2E8F0;
        border-radius: 46px;
        box-shadow: 0 35px 80px -15px rgba(15, 23, 42, 0.16), 0 8px 24px rgba(15, 23, 42, 0.08);
        display: flex;
        flex-direction: column;
        overflow: hidden;
    }
    
    /* Tablet Camera Bezel Indicator */
    .tablet-bezel-camera {
        position: absolute;
        top: -14px;
        left: 50%;
        transform: translateX(-50%);
        width: 10px;
        height: 10px;
        background: #334155;
        border-radius: 50%;
        z-index: 30;
    }
    
    /* Tablet Status Bar */
    .status-bar {
        height: 52px;
        padding: 0 38px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: #FFFFFF;
        color: #0F172A;
        font-size: 19px;
        font-weight: 700;
        letter-spacing: 0.5px;
        z-index: 20;
        flex-shrink: 0;
        border-bottom: 1.5px solid #F1F5F9;
    }
    
    .status-icons {
        display: flex;
        align-items: center;
        gap: 14px;
    }
    
    /* App Canvas inside Tablet */
    .app-screen {
        flex: 1;
        background: #F8FAFC;
        display: flex;
        flex-direction: column;
        overflow: hidden;
        color: #0F172A;
    }
    
    .app-bar {
        height: 90px;
        padding: 0 40px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        background: #FFFFFF;
        border-bottom: 1.5px solid #E2E8F0;
        flex-shrink: 0;
    }
    
    .app-bar-brand {
        display: flex;
        align-items: center;
        gap: 18px;
    }
    
    .app-bar-icon {
        width: 52px;
        height: 52px;
        border-radius: 14px;
        background: #E0F2FE;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #0284C7;
    }
    
    .app-bar-title {
        font-size: 26px;
        font-weight: 800;
        color: #0F172A;
        letter-spacing: -0.3px;
    }
    
    .app-bar-subtitle {
        font-size: 15px;
        color: #64748B;
        margin-top: 2px;
    }
    
    .app-content {
        flex: 1;
        padding: 30px 42px;
        display: flex;
        flex-direction: column;
        gap: 18px;
        overflow: hidden;
    }
    
    /* Cards and Grids */
    .custom-card {
        background: #FFFFFF;
        border: 1.5px solid #E2E8F0;
        border-radius: 20px;
        padding: 24px 28px;
        box-shadow: 0 2px 8px rgba(15, 23, 42, 0.04);
    }
    
    .hero-card {
        background: #FFFFFF;
        border: 2px solid #BAE6FD;
        border-radius: 22px;
        padding: 28px 32px;
        box-shadow: 0 4px 16px rgba(2, 132, 199, 0.08);
    }
    
    .pill-tag {
        display: inline-block;
        padding: 6px 14px;
        border-radius: 8px;
        font-size: 13px;
        font-weight: 800;
        letter-spacing: 0.5px;
        text-transform: uppercase;
    }
    
    .pill-blue {
        background: #E0F2FE;
        color: #0369A1;
    }
    
    .pill-green {
        background: #DCFCE7;
        color: #15803D;
    }
    
    .pill-amber {
        background: #FEF3C7;
        color: #B45309;
    }
    
    .btn-primary {
        background: #0284C7;
        color: #FFFFFF;
        font-weight: 800;
        font-size: 20px;
        border-radius: 16px;
        padding: 20px 26px;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 12px;
        border: none;
        box-shadow: 0 4px 14px rgba(2, 132, 199, 0.25);
    }
    
    .progress-bar-bg {
        width: 100%;
        height: 14px;
        background: #E2E8F0;
        border-radius: 7px;
        overflow: hidden;
    }
    
    .progress-bar-fill {
        height: 100%;
        background: #0284C7;
        border-radius: 7px;
    }
    
    /* Bottom Navigation */
    .bottom-nav {
        height: 88px;
        background: #FFFFFF;
        border-top: 1.5px solid #E2E8F0;
        display: flex;
        justify-content: space-around;
        align-items: center;
        padding: 0 48px;
        flex-shrink: 0;
    }
    
    .nav-item {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 6px;
        font-size: 14px;
        font-weight: 700;
        color: #94A3B8;
    }
    
    .nav-item.active {
        color: #0284C7;
    }
    
    /* Footer */
    .footer-text {
        position: relative;
        z-index: 10;
        font-size: 22px;
        font-weight: 600;
        color: #64748B;
        text-align: center;
        margin-top: 22px;
        letter-spacing: 0.5px;
    }
    """

def get_svg_backdrop():
    return """
    <svg class="bg-roads" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1600 2560">
        <path d="M-150,550 C500,680 950,1050 1750,980" fill="none" stroke="#E2E8F0" stroke-width="10" stroke-dasharray="28 28" opacity="0.6"/>
        <path d="M-200,2050 C400,1800 1000,2250 1800,2000" fill="none" stroke="#E2E8F0" stroke-width="10" stroke-dasharray="28 28" opacity="0.6"/>
        <circle cx="1400" cy="220" r="380" fill="#FEF3C7" opacity="0.35" filter="blur(100px)"/>
        <circle cx="200" cy="2350" r="420" fill="#E0F2FE" opacity="0.45" filter="blur(110px)"/>
    </svg>
    """

def build_status_bar():
    return """
    <div class="status-bar">
        <span>1:11</span>
        <div class="status-icons">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12 3c-4.97 0-9 4.03-9 9 0 2.12.74 4.07 1.97 5.61L12 22l7.03-4.39C20.26 16.07 21 14.12 21 12c0-4.97-4.03-9-9-9zm0 16.5l-4.5-2.81C6.58 15.48 6 13.82 6 12c0-3.31 2.69-6 6-6s6 2.69 6 6c0 1.82-.58 3.48-1.5 4.69L12 19.5z"/>
            </svg>
            <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12 4C7.31 4 3.07 5.9 0 8.98L12 21 24 8.98C20.93 5.9 16.69 4 12 4z"/>
            </svg>
            <svg width="26" height="22" viewBox="0 0 24 24" fill="currentColor">
                <path d="M17 4h-3V2h-4v2H7v18h10V4zm-2 16H9V6h6v14z"/>
            </svg>
        </div>
    </div>
    """

def build_bottom_nav(active_idx=0):
    tabs = [
        ("Home", '<path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/>'),
        ("Practice", '<path d="M18 2H6c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zM6 4h5v8l-2.5-1.5L6 12V4z"/>'),
        ("Mock Test", '<path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>'),
        ("Progress", '<path d="M16 6l2.29 2.29-4.88 4.88-4-4L2 16.59 3.41 18l6-6 4 4 6.3-6.29L22 12V6z"/>')
    ]
    html = '<div class="bottom-nav">'
    for i, (name, path) in enumerate(tabs):
        active_class = "active" if i == active_idx else ""
        fill = "#0284C7" if i == active_idx else "#94A3B8"
        html += f"""
        <div class="nav-item {active_class}">
            <svg width="28" height="28" viewBox="0 0 24 24" fill="{fill}">{path}</svg>
            <span>{name}</span>
        </div>
        """
    html += '</div>'
    return html

def render_tablet_screenshot(html_content, out_base_path):
    temp_html = out_base_path + '_temp.html'
    temp_png = out_base_path + '.png'
    out_jpg = out_base_path + '.jpg'
    
    with open(temp_html, 'w', encoding='utf-8') as f:
        f.write(html_content)
    
    cmd = [
        CHROME_PATH,
        '--headless=new',
        '--disable-gpu',
        '--no-sandbox',
        '--hide-scrollbars',
        '--window-size=1600,2560',
        f'--screenshot={temp_png}',
        temp_html
    ]
    res = subprocess.run(cmd, capture_output=True, text=True)
    if res.returncode == 0 and os.path.exists(temp_png):
        img = Image.open(temp_png).convert('RGB')
        img.save(out_jpg, 'JPEG', quality=95)
        print(f"Generated: {out_jpg} ({img.size})")
        if os.path.exists(temp_png):
            os.remove(temp_png)
    else:
        print(f"Failed to generate {out_jpg}, stderr: {res.stderr}")
    
    if os.path.exists(temp_html):
        os.remove(temp_html)


# ==========================================
# TABLET SCREENSHOT 1: HOME DASHBOARD
# ==========================================
def build_tablet_1():
    content = f"""<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
    {get_tablet_base_css()}
</style>
</head>
<body>
    <div class="bg-gradient"></div>
    {get_svg_backdrop()}
    
    <div class="header-area">
        <h1 class="headline">Prepare for the <span class="blue">LTO exam</span></h1>
        <p class="subtext">Practice questions, mock tests, road signs</p>
    </div>
    
    <div class="tablet-frame">
        <div class="tablet-bezel-camera"></div>
        {build_status_bar()}
        
        <div class="app-screen">
            <!-- App Bar -->
            <div class="app-bar">
                <div class="app-bar-brand">
                    <div class="app-bar-icon">
                        <svg width="32" height="32" viewBox="0 0 24 24" fill="#0284C7">
                            <path d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.21.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99zM6.5 16c-.83 0-1.5-.67-1.5-1.5S5.67 13 6.5 13s1.5.67 1.5 1.5S7.33 16 6.5 16zm11 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zM5 11l1.5-4.5h11L19 11H5z"/>
                        </svg>
                    </div>
                    <div>
                        <div class="app-bar-title">LTO Exam Coach</div>
                        <div class="app-bar-subtitle">Philippines Driving Exam Reviewer</div>
                    </div>
                </div>
                <div style="color: #64748B;">
                    <svg width="28" height="28" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M19.14 12.94c.04-.3.06-.61.06-.94 0-.32-.02-.64-.07-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94l-.36-2.54c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.57-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58c-.05.3-.09.63-.09.94s.02.64.07.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32c.12.22.37.29.59.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .44-.17.47-.41l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.22.07-.47-.12-.61l-2.01-1.58zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6z"/>
                    </svg>
                </div>
            </div>
            
            <div class="app-content">
                <!-- Top Row: Greeting & Vehicle Selection -->
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <div style="font-size: 34px; font-weight: 800; color: #0F172A; letter-spacing: -0.5px;">Ready to practice?</div>
                        <div style="font-size: 17px; color: #64748B; margin-top: 4px;">Philippines Driver's License Reviewer</div>
                    </div>
                    <div style="display: flex; align-items: center; gap: 12px; background: #E0F2FE; border: 1.5px solid #BAE6FD; padding: 12px 26px; border-radius: 26px; font-size: 16px; font-weight: 700; color: #0284C7;">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M3 17v2h6v-2H3zM3 5v2h10V5H3zm10 16v-2h8v-2h-8v-2h-2v6h2zM7 9v2H3v2h4v2h2V9H7zm14 4v-2H11v2h10zm-6-4h2V7h4V5h-4V3h-2v6z"/>
                        </svg>
                        Preparing for: Car & Motorcycle
                    </div>
                </div>
                
                <!-- Main 2-Column Responsive Layout -->
                <div style="display: grid; grid-template-columns: 1.22fr 1fr; gap: 26px;">
                    <!-- Left Column -->
                    <div style="display: flex; flex-direction: column; gap: 20px;">
                        <!-- Hero Card: Continue Practice -->
                        <div class="hero-card">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px;">
                                <span class="pill-tag pill-blue">DAILY STUDY</span>
                                <span style="font-size: 18px; font-weight: 800; color: #0284C7;">0% Covered</span>
                            </div>
                            <div style="font-size: 30px; font-weight: 800; color: #0F172A;">Continue Practice</div>
                            <div style="font-size: 17px; color: #64748B; margin-top: 6px;">150 Questions Left to Review in Question Bank</div>
                            <div class="progress-bar-bg" style="margin: 22px 0 24px 0; height: 14px;">
                                <div class="progress-bar-fill" style="width: 12%;"></div>
                            </div>
                            <button class="btn-primary" style="width: 100%; padding: 20px;">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor"><path d="M8 5v14l11-7z"/></svg>
                                Start Practice
                            </button>
                        </div>
                        
                        <!-- Today's Summary -->
                        <div class="custom-card" style="padding: 24px 28px;">
                            <div style="font-size: 21px; font-weight: 800; color: #0F172A; margin-bottom: 18px;">Today's Summary</div>
                            <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px;">
                                <div style="background: #F8FAFC; border: 1.5px solid #E2E8F0; border-radius: 16px; padding: 20px 14px; text-align: center;">
                                    <div style="width: 44px; height: 44px; background: #E0F2FE; border-radius: 12px; display: inline-flex; align-items: center; justify-content: center; color: #0284C7; margin-bottom: 8px;">
                                        <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>
                                    </div>
                                    <div style="font-size: 28px; font-weight: 900; color: #0F172A;">0</div>
                                    <div style="font-size: 14px; color: #64748B; font-weight: 600;">Today</div>
                                </div>
                                <div style="background: #F8FAFC; border: 1.5px solid #E2E8F0; border-radius: 16px; padding: 20px 14px; text-align: center;">
                                    <div style="width: 44px; height: 44px; background: #DCFCE7; border-radius: 12px; display: inline-flex; align-items: center; justify-content: center; color: #15803D; margin-bottom: 8px;">
                                        <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor"><path d="M5 9.2h3V19H5zM10.6 5h2.8v14h-2.8zm5.6 8H19v6h-2.8z"/></svg>
                                    </div>
                                    <div style="font-size: 28px; font-weight: 900; color: #0F172A;">0%</div>
                                    <div style="font-size: 14px; color: #64748B; font-weight: 600;">Accuracy</div>
                                </div>
                                <div style="background: #F8FAFC; border: 1.5px solid #E2E8F0; border-radius: 16px; padding: 20px 14px; text-align: center;">
                                    <div style="width: 44px; height: 44px; background: #FEF3C7; border-radius: 12px; display: inline-flex; align-items: center; justify-content: center; color: #B45309; margin-bottom: 8px;">
                                        <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor"><path d="M12 23c6.075 0 11-4.925 11-11 0-4.004-2.146-7.514-5.35-9.429l-.65-.386-.145.744c-.318 1.637-1.127 3.08-2.298 4.148C13.882 7.7 13 8.766 13 10c0 1.103.897 2 2 2 .551 0 1-.449 1-1 0-.323-.153-.611-.39-.791l-.226-.172.284-.012c1.948-.083 3.551.996 4.184 2.835C20.479 14.73 19.381 18 16.5 19.5c-1.393.727-2.97.91-4.5.522-2.348-.596-4.225-2.473-4.821-4.821-.655-2.58.261-5.118 2.062-6.726l.461-.41-.595-.152C7.306 7.46 6.002 9.588 6.002 12c0 6.075 4.925 11 10.998 11z"/></svg>
                                    </div>
                                    <div style="font-size: 28px; font-weight: 900; color: #0F172A;">0 Days</div>
                                    <div style="font-size: 14px; color: #64748B; font-weight: 600;">Streak</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Right Column: Study Modes & Review -->
                    <div style="display: flex; flex-direction: column; gap: 14px;">
                        <div style="font-size: 21px; font-weight: 800; color: #0F172A;">Study Modes & Review</div>
                        
                        <div class="custom-card" style="padding: 20px 24px; display: flex; align-items: center; justify-content: space-between;">
                            <div style="display: flex; align-items: center; gap: 16px;">
                                <div style="width: 48px; height: 48px; background: #E0F2FE; border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #0284C7;">
                                    <svg width="26" height="26" viewBox="0 0 24 24" fill="currentColor"><path d="M18 2H6c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zM6 4h5v8l-2.5-1.5L6 12V4z"/></svg>
                                </div>
                                <div>
                                    <div style="font-size: 19px; font-weight: 800; color: #0F172A;">Practice Questions</div>
                                    <div style="font-size: 14px; color: #64748B;">Topic Practice</div>
                                </div>
                            </div>
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="#94A3B8"><path d="M8.59 16.59L13.17 12 8.59 7.41 10 6l6 6-6 6-1.41-1.41z"/></svg>
                        </div>
                        
                        <div class="custom-card" style="padding: 20px 24px; display: flex; align-items: center; justify-content: space-between;">
                            <div style="display: flex; align-items: center; gap: 16px;">
                                <div style="width: 48px; height: 48px; background: #DCFCE7; border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #15803D;">
                                    <svg width="26" height="26" viewBox="0 0 24 24" fill="currentColor"><path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm.5-13H11v6l5.25 3.15.75-1.23-4.5-2.67z"/></svg>
                                </div>
                                <div>
                                    <div style="font-size: 19px; font-weight: 800; color: #0F172A;">Mock Exam</div>
                                    <div style="font-size: 14px; color: #64748B;">Timed Simulation</div>
                                </div>
                            </div>
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="#94A3B8"><path d="M8.59 16.59L13.17 12 8.59 7.41 10 6l6 6-6 6-1.41-1.41z"/></svg>
                        </div>
                        
                        <div class="custom-card" style="padding: 20px 24px; display: flex; align-items: center; justify-content: space-between;">
                            <div style="display: flex; align-items: center; gap: 16px;">
                                <div style="width: 48px; height: 48px; background: #FEE2E2; border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #B91C1C;">
                                    <svg width="26" height="26" viewBox="0 0 24 24" fill="currentColor"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg>
                                </div>
                                <div>
                                    <div style="font-size: 19px; font-weight: 800; color: #0F172A;">Wrong Answers</div>
                                    <div style="font-size: 14px; color: #64748B;">Mistake Bank</div>
                                </div>
                            </div>
                            <span style="font-size: 17px; font-weight: 800; color: #94A3B8;">0 ›</span>
                        </div>
                        
                        <div class="custom-card" style="padding: 20px 24px; display: flex; align-items: center; justify-content: space-between;">
                            <div style="display: flex; align-items: center; gap: 16px;">
                                <div style="width: 48px; height: 48px; background: #FEF3C7; border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #B45309;">
                                    <svg width="26" height="26" viewBox="0 0 24 24" fill="currentColor"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>
                                </div>
                                <div>
                                    <div style="font-size: 19px; font-weight: 800; color: #0F172A;">Favorites</div>
                                    <div style="font-size: 14px; color: #64748B;">Bookmarked Items</div>
                                </div>
                            </div>
                            <span style="font-size: 17px; font-weight: 800; color: #94A3B8;">0 ›</span>
                        </div>
                    </div>
                </div>

                <!-- Lower Section: Category Readiness Breakdown Grid -->
                <div class="custom-card" style="padding: 24px 30px;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                        <div>
                            <div style="font-size: 21px; font-weight: 800; color: #0F172A;">Topic Mastery Progress</div>
                            <div style="font-size: 14px; color: #64748B; margin-top: 2px;">Core curriculum areas evaluated for licensing</div>
                        </div>
                        <span class="pill-tag pill-blue">150 Questions Total</span>
                    </div>
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px 36px;">
                        <div>
                            <div style="display: flex; justify-content: space-between; font-size: 16px; font-weight: 700; margin-bottom: 8px;">
                                <span>General Driving Knowledge</span>
                                <span style="color: #0284C7;">35 Questions</span>
                            </div>
                            <div class="progress-bar-bg" style="height: 10px;"><div class="progress-bar-fill" style="width: 20%;"></div></div>
                        </div>
                        <div>
                            <div style="display: flex; justify-content: space-between; font-size: 16px; font-weight: 700; margin-bottom: 8px;">
                                <span>Traffic Rules & Regulations</span>
                                <span style="color: #0284C7;">40 Questions</span>
                            </div>
                            <div class="progress-bar-bg" style="height: 10px;"><div class="progress-bar-fill" style="width: 15%;"></div></div>
                        </div>
                        <div>
                            <div style="display: flex; justify-content: space-between; font-size: 16px; font-weight: 700; margin-bottom: 8px;">
                                <span>Road Signs & Markings</span>
                                <span style="color: #0284C7;">35 Questions</span>
                            </div>
                            <div class="progress-bar-bg" style="height: 10px;"><div class="progress-bar-fill" style="width: 25%;"></div></div>
                        </div>
                        <div>
                            <div style="display: flex; justify-content: space-between; font-size: 16px; font-weight: 700; margin-bottom: 8px;">
                                <span>Defensive Driving & Safety</span>
                                <span style="color: #0284C7;">40 Questions</span>
                            </div>
                            <div class="progress-bar-bg" style="height: 10px;"><div class="progress-bar-fill" style="width: 10%;"></div></div>
                        </div>
                    </div>
                </div>

                <!-- Road Signs Spotlight Banner -->
                <div class="custom-card" style="background: linear-gradient(135deg, #F0FDF4 0%, #FFFFFF 100%); border-color: #86EFAC; padding: 22px 28px; display: flex; align-items: center; justify-content: space-between;">
                    <div style="display: flex; align-items: center; gap: 18px;">
                        <div style="width: 52px; height: 52px; background: #DCFCE7; border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 28px;">
                            🚦
                        </div>
                        <div>
                            <div style="font-size: 19px; font-weight: 800; color: #15803D;">45 Philippine Road Signs Visual Catalog</div>
                            <div style="font-size: 15px; color: #475569; margin-top: 2px;">Regulatory, Warning, and Informative signs in high-resolution vector artwork.</div>
                        </div>
                    </div>
                    <span class="pill-tag pill-green" style="font-size: 14px; padding: 8px 18px;">EXPLORE CATALOG ›</span>
                </div>
            </div>
            
            {build_bottom_nav(0)}
        </div>
    </div>
    
    <div class="footer-text">LTO Exam Coach Philippines</div>
</body>
</html>"""
    out_file = os.path.join(OUT_DIR, 'tablet-01-home')
    render_tablet_screenshot(content, out_file)


# ==========================================
# TABLET SCREENSHOT 2: PRACTICE BY TOPIC
# ==========================================
def build_tablet_2():
    topics = [
        ("Traffic Rules & Regulations", "25 Questions", "#0284C7", "#E0F2FE", '<path d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.21.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99z"/>'),
        ("Road Signs & Markings", "20 Questions", "#D97706", "#FEF3C7", '<path d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/>'),
        ("Right of Way & Intersections", "15 Questions", "#059669", "#D1FAE5", '<path d="M12 4l-1.41 1.41L16.17 11H4v2h12.17l-5.58 5.59L12 20l8-8z"/>'),
        ("Overtaking & Lane Maneuvers", "10 Questions", "#7C3AED", "#EDE9FE", '<path d="M4 18l8.5-6L4 6v12zm9-12v12l8.5-6L13 6z"/>'),
        ("Speed Limits & Safe Distance", "15 Questions", "#DC2626", "#FEE2E2", '<path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm-1-13h2v6h-2zm0 8h2v2h-2z"/>'),
        ("Defensive Driving & Hazards", "20 Questions", "#0D9488", "#CCFBF1", '<path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm-2 16l-4-4 1.41-1.41L10 14.17l6.59-6.59L18 9l-8 8z"/>'),
        ("Emergencies & Breakdowns", "15 Questions", "#E11D48", "#FFE4E6", '<path d="M12 2C6.5 2 2 6.5 2 12s4.5 10 10 10 10-4.5 10-10S17.5 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/>'),
        ("Anti-Drunk Driving (RA 10586)", "10 Questions", "#B45309", "#FEF3C7", '<path d="M12 2L4 5v6.09c0 5.05 3.41 9.76 8 10.91 4.59-1.15 8-5.86 8-10.91V5l-8-3z"/>'),
        ("Fines, Violations & Demerits", "10 Questions", "#475569", "#F1F5F9", '<path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>'),
        ("Vehicle Operations & Safety", "10 Questions", "#0284C7", "#E0F2FE", '<path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 17.93c-3.95-.49-7-3.85-7-7.93 0-.62.08-1.21.21-1.79L9 15v1c0 1.1.9 2 2 2v1.93zm6.9-2.54c-.26-.81-1-1.39-1.9-1.39h-1v-3c0-.55-.45-1-1-1H8v-2h2c.55 0 1-.45 1-1V7h2c1.1 0 2-.9 2-2v-.41c2.93 1.19 5 4.06 5 7.41 0 2.08-.8 3.97-2.1 5.39z"/>')
    ]
    
    topics_html = ""
    for name, q_count, color, bg, svg_path in topics:
        topics_html += f"""
        <div class="custom-card" style="padding: 20px 24px; display: flex; align-items: center; justify-content: space-between;">
            <div style="display: flex; align-items: center; gap: 16px;">
                <div style="width: 48px; height: 48px; background: {bg}; border-radius: 12px; display: flex; align-items: center; justify-content: center; color: {color};">
                    <svg width="26" height="26" viewBox="0 0 24 24" fill="currentColor">{svg_path}</svg>
                </div>
                <div>
                    <div style="font-size: 18px; font-weight: 800; color: #0F172A;">{name}</div>
                    <div style="font-size: 14px; color: #64748B; margin-top: 2px;">{q_count}</div>
                </div>
            </div>
            <svg width="22" height="22" viewBox="0 0 24 24" fill="#94A3B8"><path d="M8.59 16.59L13.17 12 8.59 7.41 10 6l6 6-6 6-1.41-1.41z"/></svg>
        </div>
        """

    content = f"""<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
    {get_tablet_base_css()}
</style>
</head>
<body>
    <div class="bg-gradient"></div>
    {get_svg_backdrop()}
    
    <div class="header-area">
        <h1 class="headline">Practice by <span class="blue">topic</span></h1>
        <p class="subtext">150 questions with instant feedback</p>
    </div>
    
    <div class="tablet-frame">
        <div class="tablet-bezel-camera"></div>
        {build_status_bar()}
        
        <div class="app-screen">
            <div class="app-bar">
                <div class="app-bar-brand">
                    <div class="app-bar-icon">
                        <svg width="32" height="32" viewBox="0 0 24 24" fill="#0284C7">
                            <path d="M18 2H6c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zM6 4h5v8l-2.5-1.5L6 12V4z"/>
                        </svg>
                    </div>
                    <div>
                        <div class="app-bar-title">Practice by Topic</div>
                        <div class="app-bar-subtitle">150 Questions Across 11 Categories</div>
                    </div>
                </div>
                <div style="color: #64748B;">
                    <svg width="28" height="28" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M10.59 9.17L5.41 4 4 5.41l5.17 5.17 1.42-1.41zM14.5 4l2.04 2.04L4 18.59 5.41 20 17.96 7.46 20 9.5V4h-5.5zm.33 9.41l-1.41 1.41 3.13 3.13L14.5 20H20v-5.5l-2.04 2.04-3.13-3.13z"/>
                    </svg>
                </div>
            </div>
            
            <div class="app-content">
                <!-- Vehicle Mode & All Questions Header -->
                <div style="display: flex; gap: 24px; align-items: stretch;">
                    <div class="hero-card" style="flex: 1.4; padding: 22px 28px; display: flex; align-items: center; justify-content: space-between;">
                        <div style="display: flex; align-items: center; gap: 18px;">
                            <div style="width: 52px; height: 52px; background: #E0F2FE; border-radius: 14px; display: flex; align-items: center; justify-content: center; color: #0284C7;">
                                <svg width="28" height="28" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 14H9V8h2v8zm4 0h-2V8h2v8z"/></svg>
                            </div>
                            <div>
                                <div style="font-size: 22px; font-weight: 800; color: #0F172A;">All Questions Practice</div>
                                <div style="font-size: 15px; color: #64748B; margin-top: 2px;">Comprehensive test preparation • 150 Qs</div>
                            </div>
                        </div>
                        <button class="btn-primary" style="padding: 14px 28px; font-size: 17px;">Start All</button>
                    </div>
                    
                    <div class="custom-card" style="flex: 1; padding: 22px 26px; display: flex; align-items: center; justify-content: space-between;">
                        <div>
                            <div style="font-size: 14px; color: #64748B; font-weight: 700;">ACTIVE LICENSE MODE</div>
                            <div style="font-size: 20px; font-weight: 800; color: #0284C7; margin-top: 4px;">Car & Motorcycle (Both)</div>
                        </div>
                        <span class="pill-tag pill-blue" style="font-size: 13px;">CHANGE</span>
                    </div>
                </div>
                
                <!-- Targeted Practice Row -->
                <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px;">
                    <div class="custom-card" style="padding: 20px 22px; display: flex; align-items: center; gap: 16px;">
                        <div style="width: 44px; height: 44px; background: #FEE2E2; border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #B91C1C;">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.47 2 2 6.47 2 12s4.47 10 10 10 10-4.47 10-10S17.53 2 12 2zm5 13.59L15.59 17 12 13.41 8.41 17 7 15.59 10.59 12 7 8.41 8.41 7 12 10.59 15.59 7 17 8.41 13.41 12 17 13.59z"/></svg>
                        </div>
                        <div>
                            <div style="font-size: 17px; font-weight: 800; color: #0F172A;">Mistakes Bank</div>
                            <div style="font-size: 13px; color: #64748B;">Auto-saved review</div>
                        </div>
                    </div>
                    
                    <div class="custom-card" style="padding: 20px 22px; display: flex; align-items: center; gap: 16px;">
                        <div style="width: 44px; height: 44px; background: #FFE4E6; border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #E11D48;">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>
                        </div>
                        <div>
                            <div style="font-size: 17px; font-weight: 800; color: #0F172A;">Favorites</div>
                            <div style="font-size: 13px; color: #64748B;">Saved questions</div>
                        </div>
                    </div>
                    
                    <div class="custom-card" style="padding: 20px 22px; display: flex; align-items: center; gap: 16px;">
                        <div style="width: 44px; height: 44px; background: #FEF3C7; border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #B45309;">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor"><path d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/></svg>
                        </div>
                        <div>
                            <div style="font-size: 17px; font-weight: 800; color: #0F172A;">Difficult Items</div>
                            <div style="font-size: 13px; color: #64748B;">Tagged for revision</div>
                        </div>
                    </div>
                </div>

                <!-- Road Signs Visual Guide Card -->
                <div class="custom-card" style="background: linear-gradient(135deg, #FEF3C7 0%, #FFFFFF 100%); border-color: #FCD34D; padding: 22px 28px; display: flex; align-items: center; justify-content: space-between;">
                    <div style="display: flex; align-items: center; gap: 18px;">
                        <div style="width: 52px; height: 52px; background: #FEF3C7; border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 28px;">
                            🛑
                        </div>
                        <div>
                            <div style="font-size: 19px; font-weight: 800; color: #B45309;">Road Signs Visual Catalog (45 Vector Signs)</div>
                            <div style="font-size: 14px; color: #78350F; margin-top: 2px;">Explore Regulatory, Warning & Informative signs with interactive recognition quiz.</div>
                        </div>
                    </div>
                    <span class="pill-tag pill-amber" style="font-size: 14px; padding: 8px 18px;">45 SIGNS ›</span>
                </div>
                
                <!-- Topics 2-Column Grid -->
                <div>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px;">
                        <div style="font-size: 21px; font-weight: 800; color: #0F172A;">Curriculum Topics</div>
                        <span style="font-size: 15px; font-weight: 700; color: #0284C7;">11 Categories Available</span>
                    </div>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 14px;">
                        {topics_html}
                    </div>
                </div>
            </div>
            
            {build_bottom_nav(1)}
        </div>
    </div>
    
    <div class="footer-text">LTO Exam Coach Philippines</div>
</body>
</html>"""
    out_file = os.path.join(OUT_DIR, 'tablet-02-practice')
    render_tablet_screenshot(content, out_file)


# ==========================================
# TABLET SCREENSHOT 3: TIMED MOCK EXAMS
# ==========================================
def build_tablet_3():
    content = f"""<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
    {get_tablet_base_css()}
</style>
</head>
<body>
    <div class="bg-gradient"></div>
    {get_svg_backdrop()}
    
    <div class="header-area">
        <h1 class="headline">Timed <span class="blue">mock exams</span></h1>
        <p class="subtext">Simulate the real test, then review</p>
    </div>
    
    <div class="tablet-frame">
        <div class="tablet-bezel-camera"></div>
        {build_status_bar()}
        
        <div class="app-screen">
            <div class="app-bar">
                <div class="app-bar-brand">
                    <div class="app-bar-icon">
                        <svg width="32" height="32" viewBox="0 0 24 24" fill="#0284C7">
                            <path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm.5-13H11v6l5.25 3.15.75-1.23-4.5-2.67z"/>
                        </svg>
                    </div>
                    <div>
                        <div class="app-bar-title">Mock Exam Simulator</div>
                        <div class="app-bar-subtitle">Timed Practice with 80% Benchmark</div>
                    </div>
                </div>
                <span class="pill-tag pill-green" style="font-size: 14px; padding: 8px 16px;">READY TO TEST</span>
            </div>
            
            <div class="app-content">
                <!-- Dual Column Layout for Tablet -->
                <div style="display: grid; grid-template-columns: 1fr 1.25fr; gap: 28px; flex: 1;">
                    <!-- Left Column: Setup & Rules -->
                    <div style="display: flex; flex-direction: column; gap: 20px;">
                        <!-- Hero Simulation Card -->
                        <div class="hero-card" style="padding: 24px 28px;">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px;">
                                <span class="pill-tag pill-blue">⏱️ TIMED SIMULATION</span>
                                <span class="pill-tag pill-green">80% Benchmark</span>
                            </div>
                            <div style="font-size: 26px; font-weight: 800; color: #0F172A;">Realistic Driving Exam Simulation</div>
                            <div style="font-size: 16px; color: #64748B; margin-top: 6px; line-height: 1.4;">Experience real examination conditions with active countdown timer and score breakdown.</div>
                        </div>
                        
                        <!-- Question Count Select -->
                        <div>
                            <div style="font-size: 18px; font-weight: 800; color: #0F172A; margin-bottom: 12px;">Select Question Count</div>
                            <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 12px;">
                                <div style="background: #E0F2FE; border: 2px solid #0284C7; border-radius: 14px; padding: 18px 12px; font-size: 18px; font-weight: 800; color: #0284C7; text-align: center;">
                                    ✓ 20 Qs
                                </div>
                                <div style="background: #FFFFFF; border: 1.5px solid #E2E8F0; border-radius: 14px; padding: 18px 12px; font-size: 18px; font-weight: 700; color: #64748B; text-align: center;">
                                    30 Qs
                                </div>
                                <div style="background: #FFFFFF; border: 1.5px solid #E2E8F0; border-radius: 14px; padding: 18px 12px; font-size: 18px; font-weight: 700; color: #64748B; text-align: center;">
                                    40 Qs
                                </div>
                            </div>
                        </div>

                        <!-- Target Vehicle Mode -->
                        <div>
                            <div style="font-size: 18px; font-weight: 800; color: #0F172A; margin-bottom: 12px;">Target Vehicle Mode</div>
                            <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 12px;">
                                <div style="background: #FFFFFF; border: 1.5px solid #E2E8F0; border-radius: 14px; padding: 16px; text-align: center; font-size: 16px; font-weight: 700; color: #475569;">
                                    🚗 Car
                                </div>
                                <div style="background: #FFFFFF; border: 1.5px solid #E2E8F0; border-radius: 14px; padding: 16px; text-align: center; font-size: 16px; font-weight: 700; color: #475569;">
                                    🏍️ Motorcycle
                                </div>
                                <div style="background: #DCFCE7; border: 2px solid #15803D; border-radius: 14px; padding: 16px; text-align: center; font-size: 16px; font-weight: 800; color: #15803D;">
                                    ✓ Both
                                </div>
                            </div>
                        </div>
                        
                        <!-- Exam Details Card -->
                        <div class="custom-card" style="padding: 22px 26px;">
                            <div style="font-size: 18px; font-weight: 800; color: #0F172A; margin-bottom: 14px;">Simulation Parameters</div>
                            <div style="display: flex; flex-direction: column; gap: 12px;">
                                <div style="display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid #F1F5F9; padding-bottom: 10px;">
                                    <span style="font-size: 15px; color: #64748B;">⏱️ Time Limit</span>
                                    <span style="font-size: 15px; font-weight: 800; color: #0F172A;">20 Minutes (1 min/Q)</span>
                                </div>
                                <div style="display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid #F1F5F9; padding-bottom: 10px;">
                                    <span style="font-size: 15px; color: #64748B;">🎯 Passing Benchmark</span>
                                    <span style="font-size: 15px; font-weight: 800; color: #15803D;">80% Target Score</span>
                                </div>
                                <div style="display: flex; align-items: center; justify-content: space-between;">
                                    <span style="font-size: 15px; color: #64748B;">📋 Pool Source</span>
                                    <span style="font-size: 15px; font-weight: 800; color: #0F172A;">Randomized from 150 Qs</span>
                                </div>
                            </div>
                        </div>

                        <!-- Recent Mock Results -->
                        <div class="custom-card" style="background: #F0FDF4; border-color: #86EFAC; padding: 18px 22px; display: flex; align-items: center; justify-content: space-between;">
                            <div>
                                <div style="font-size: 16px; font-weight: 800; color: #15803D;">Recent Benchmark: PASS 🏆</div>
                                <div style="font-size: 13px; color: #475569; margin-top: 2px;">Last Simulation Score: 18 / 20 (90%)</div>
                            </div>
                            <span class="pill-tag pill-green" style="font-size: 12px;">90%</span>
                        </div>
                    </div>
                    
                    <!-- Right Column: Live Mock Test Preview -->
                    <div style="display: flex; flex-direction: column; gap: 20px;">
                        <!-- Question Simulation Card -->
                        <div class="custom-card" style="border: 2px solid #BAE6FD; padding: 28px 30px; display: flex; flex-direction: column; justify-content: space-between;">
                            <div>
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px;">
                                    <span class="pill-tag pill-blue" style="font-size: 14px;">QUESTION 4 OF 20</span>
                                    <div style="display: flex; align-items: center; gap: 8px; font-size: 18px; font-weight: 800; color: #D97706;">
                                        <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor"><path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm.5-13H11v6l5.25 3.15.75-1.23-4.5-2.67z"/></svg>
                                        ⏱️ 17:42 Left
                                    </div>
                                </div>
                                
                                <div style="font-size: 14px; font-weight: 700; color: #0284C7; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 10px;">
                                    Traffic Rules & Road Markings
                                </div>
                                
                                <div style="font-size: 24px; font-weight: 800; color: #0F172A; line-height: 1.35; margin-bottom: 26px;">
                                    What does a solid yellow line on your side of the center line indicate?
                                </div>
                                
                                <!-- Options List -->
                                <div style="display: flex; flex-direction: column; gap: 14px;">
                                    <div style="background: #F8FAFC; border: 1.5px solid #E2E8F0; border-radius: 14px; padding: 18px 22px; display: flex; align-items: center; gap: 16px; font-size: 17px; font-weight: 600; color: #334155;">
                                        <span style="width: 28px; height: 28px; border-radius: 50%; border: 2px solid #CBD5E1; display: inline-flex; align-items: center; justify-content: center; font-size: 14px; font-weight: 800; color: #64748B;">A</span>
                                        <span>You may overtake if the road is clear</span>
                                    </div>
                                    <div style="background: #EFF6FF; border: 2.5px solid #0284C7; border-radius: 14px; padding: 18px 22px; display: flex; align-items: center; gap: 16px; font-size: 17px; font-weight: 800; color: #0284C7;">
                                        <span style="width: 28px; height: 28px; border-radius: 50%; background: #0284C7; color: #FFFFFF; display: inline-flex; align-items: center; justify-content: center; font-size: 14px; font-weight: 800;">B</span>
                                        <span>Overtaking and crossing the line is strictly prohibited</span>
                                    </div>
                                    <div style="background: #F8FAFC; border: 1.5px solid #E2E8F0; border-radius: 14px; padding: 18px 22px; display: flex; align-items: center; gap: 16px; font-size: 17px; font-weight: 600; color: #334155;">
                                        <span style="width: 28px; height: 28px; border-radius: 50%; border: 2px solid #CBD5E1; display: inline-flex; align-items: center; justify-content: center; font-size: 14px; font-weight: 800; color: #64748B;">C</span>
                                        <span>You must speed up to merge into the next lane</span>
                                    </div>
                                    <div style="background: #F8FAFC; border: 1.5px solid #E2E8F0; border-radius: 14px; padding: 18px 22px; display: flex; align-items: center; gap: 16px; font-size: 17px; font-weight: 600; color: #334155;">
                                        <span style="width: 28px; height: 28px; border-radius: 50%; border: 2px solid #CBD5E1; display: inline-flex; align-items: center; justify-content: center; font-size: 14px; font-weight: 800; color: #64748B;">D</span>
                                        <span>Sound your horn continuously before passing</span>
                                    </div>
                                </div>
                            </div>

                            <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1.5px solid #F1F5F9; padding-top: 18px; margin-top: 20px;">
                                <span style="font-size: 15px; color: #64748B; font-weight: 600;">Flagged for Review: 0</span>
                                <div style="display: flex; gap: 12px;">
                                    <span style="background: #F1F5F9; border: 1px solid #CBD5E1; padding: 8px 16px; border-radius: 10px; font-size: 14px; font-weight: 700; color: #475569;">Previous</span>
                                    <span style="background: #E0F2FE; border: 1px solid #BAE6FD; padding: 8px 16px; border-radius: 10px; font-size: 14px; font-weight: 700; color: #0284C7;">Next ›</span>
                                </div>
                            </div>
                        </div>

                        <!-- Reviewer Tip Box -->
                        <div style="background: #F0FDF4; border: 1.5px solid #BBF7D0; border-radius: 14px; padding: 16px 20px; display: flex; align-items: center; gap: 14px;">
                            <span style="font-size: 24px;">💡</span>
                            <div style="font-size: 15px; color: #166534; font-weight: 600; line-height: 1.4;">
                                <strong>LTO Question Tip:</strong> A solid line indicates that crossing or overtaking is hazardous and strictly prohibited by traffic regulations.
                            </div>
                        </div>
                        
                        <!-- Start Mock Exam Button -->
                        <button class="btn-primary" style="width: 100%; padding: 22px; font-size: 22px;">
                            <svg width="26" height="26" viewBox="0 0 24 24" fill="currentColor"><path d="M8 5v14l11-7z"/></svg>
                            Start Mock Exam Simulation
                        </button>
                    </div>
                </div>
            </div>
            
            {build_bottom_nav(2)}
        </div>
    </div>
    
    <div class="footer-text">LTO Exam Coach Philippines</div>
</body>
</html>"""
    out_file = os.path.join(OUT_DIR, 'tablet-03-mock-exam')
    render_tablet_screenshot(content, out_file)


if __name__ == '__main__':
    print("Regenerating rich 10-inch Tablet Screenshots for Google Play...")
    build_tablet_1()
    build_tablet_2()
    build_tablet_3()
    print("All tablet screenshots regenerated successfully in:", OUT_DIR)
