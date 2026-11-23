import os
import subprocess

OUT_DIR = os.path.abspath('play_store_screenshots')
os.makedirs(OUT_DIR, exist_ok=True)
CHROME_PATH = r'C:\Program Files\Google\Chrome\Application\chrome.exe'

def get_base_css():
    return """
    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
    }
    body {
        width: 1080px;
        height: 2400px;
        overflow: hidden;
        background: #F8FAFC;
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Inter', Helvetica, Arial, sans-serif;
        color: #0F172A;
        position: relative;
        display: flex;
        flex-direction: column;
        align-items: center;
    }
    
    /* Subtle Road Background Graphics */
    .bg-roads {
        position: absolute;
        top: 0;
        left: 0;
        width: 1080px;
        height: 2400px;
        pointer-events: none;
        z-index: 1;
        overflow: hidden;
    }
    
    /* Header Area */
    .header-area {
        position: relative;
        z-index: 10;
        width: 100%;
        padding: 56px 40px 18px 40px;
        display: flex;
        flex-direction: column;
        align-items: center;
        text-align: center;
    }
    
    .brand-pill {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        background: #FEF3C7;
        border: 1.5px solid #FCD34D;
        padding: 8px 22px;
        border-radius: 30px;
        font-size: 14px;
        font-weight: 800;
        color: #B45309;
        letter-spacing: 2px;
        text-transform: uppercase;
        margin-bottom: 12px;
    }
    
    .headline {
        font-size: 60px;
        font-weight: 900;
        color: #0F172A;
        line-height: 1.14;
        letter-spacing: -1.2px;
        max-width: 980px;
    }
    
    .headline span.gold {
        color: #D97706;
    }
    
    .headline span.blue {
        color: #0284C7;
    }
    
    .subtext {
        font-size: 28px;
        font-weight: 500;
        color: #64748B;
        margin-top: 10px;
        line-height: 1.35;
        max-width: 920px;
    }
    
    /* Phone Mockup Frame (Crisp White / Light Slate Device) */
    .phone-container {
        position: relative;
        z-index: 10;
        width: 940px;
        height: 2020px;
        margin-top: 10px;
        background: #FFFFFF;
        border: 14px solid #FFFFFF;
        outline: 2px solid #E2E8F0;
        border-radius: 56px;
        box-shadow: 0 25px 60px -15px rgba(15, 23, 42, 0.12), 0 4px 20px rgba(15, 23, 42, 0.05);
        display: flex;
        flex-direction: column;
        overflow: hidden;
    }
    
    /* Phone Status Bar */
    .status-bar {
        height: 52px;
        padding: 0 38px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: #FFFFFF;
        color: #0F172A;
        font-size: 18px;
        font-weight: 700;
        letter-spacing: 0.5px;
        z-index: 20;
        flex-shrink: 0;
        border-bottom: 1px solid #F1F5F9;
    }
    
    .camera-punch {
        width: 15px;
        height: 15px;
        background: #0F172A;
        border-radius: 50%;
        border: 2px solid #CBD5E1;
    }
    
    .status-icons {
        display: flex;
        align-items: center;
        gap: 12px;
    }
    
    /* App Canvas inside Phone */
    .app-screen {
        flex: 1;
        background: #F8FAFC;
        display: flex;
        flex-direction: column;
        overflow: hidden;
        color: #0F172A;
    }
    
    .app-bar {
        height: 84px;
        padding: 0 28px;
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
        gap: 16px;
    }
    
    .app-bar-icon {
        width: 48px;
        height: 48px;
        border-radius: 14px;
        background: #E0F2FE;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #0284C7;
    }
    
    .app-bar-title {
        font-size: 24px;
        font-weight: 800;
        color: #0F172A;
        letter-spacing: -0.3px;
    }
    
    .app-bar-subtitle {
        font-size: 14px;
        color: #64748B;
        margin-top: 2px;
    }
    
    .app-scroll-content {
        flex: 1;
        padding: 24px 28px;
        display: flex;
        flex-direction: column;
        gap: 20px;
        overflow: hidden;
    }
    
    /* Common UI Cards */
    .custom-card {
        background: #FFFFFF;
        border: 1.5px solid #E2E8F0;
        border-radius: 20px;
        padding: 22px 24px;
        box-shadow: 0 2px 6px rgba(15, 23, 42, 0.04);
    }
    
    .hero-card {
        background: #FFFFFF;
        border: 2px solid #BAE6FD;
        border-radius: 22px;
        padding: 26px 28px;
        box-shadow: 0 4px 16px rgba(2, 132, 199, 0.08);
    }
    
    .pill-tag {
        display: inline-block;
        padding: 6px 14px;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 800;
        letter-spacing: 0.5px;
        text-transform: uppercase;
    }
    
    .pill-cyan, .pill-blue {
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
    
    .pill-red {
        background: #FEE2E2;
        color: #B91C1C;
    }

    .pill-purple {
        background: #F3E8FF;
        color: #7E22CE;
    }
    
    .btn-primary {
        background: #0284C7;
        color: #FFFFFF;
        font-weight: 800;
        font-size: 21px;
        border-radius: 16px;
        padding: 19px 24px;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 12px;
        border: none;
        box-shadow: 0 4px 14px rgba(2, 132, 199, 0.25);
    }
    
    .btn-secondary {
        background: #F1F5F9;
        color: #0F172A;
        font-weight: 700;
        font-size: 18px;
        border-radius: 16px;
        padding: 18px 22px;
        border: 1.5px solid #CBD5E1;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
    }
    
    .progress-bar-bg {
        width: 100%;
        height: 12px;
        background: #E2E8F0;
        border-radius: 6px;
        overflow: hidden;
    }
    
    .progress-bar-fill {
        height: 100%;
        background: #0284C7;
        border-radius: 6px;
    }
    
    .stats-row {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 16px;
    }
    
    .stat-card {
        background: #FFFFFF;
        border: 1.5px solid #E2E8F0;
        border-radius: 18px;
        padding: 20px 14px;
        text-align: center;
        box-shadow: 0 2px 6px rgba(15, 23, 42, 0.04);
    }
    
    .stat-value {
        font-size: 44px;
        font-weight: 900;
        color: #0F172A;
    }
    
    .stat-label {
        font-size: 15px;
        color: #64748B;
        margin-top: 6px;
        font-weight: 600;
    }
    
    /* Quick Action 2x2 Grid */
    .quick-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 16px;
    }
    
    .action-tile {
        background: #FFFFFF;
        border: 1.5px solid #E2E8F0;
        border-radius: 18px;
        padding: 22px 22px;
        display: flex;
        flex-direction: column;
        gap: 8px;
        box-shadow: 0 2px 6px rgba(15, 23, 42, 0.04);
    }
    
    .tile-top {
        display: flex;
        align-items: center;
        justify-content: space-between;
    }
    
    .tile-icon {
        width: 48px;
        height: 48px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    
    .tile-title {
        font-size: 20px;
        font-weight: 800;
        color: #0F172A;
    }
    
    .tile-subtitle {
        font-size: 14px;
        color: #64748B;
    }
    
    /* Bottom Navigation Simulation */
    .bottom-nav {
        height: 92px;
        border-top: 1.5px solid #E2E8F0;
        background: #FFFFFF;
        display: flex;
        justify-content: space-around;
        align-items: center;
        padding: 0 10px;
        flex-shrink: 0;
    }
    
    .nav-item {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 6px;
        font-size: 13px;
        font-weight: 700;
        color: #94A3B8;
    }
    
    .nav-item.active {
        color: #0284C7;
    }
    """

def get_svg_road_backdrop():
    return """
    <svg class="bg-roads" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1080 2400">
        <!-- Subtle road curves in light slate/gray -->
        <path d="M-100,450 C400,550 700,850 1200,800" fill="none" stroke="#E2E8F0" stroke-width="8" stroke-dasharray="24 24" opacity="0.65"/>
        <path d="M-150,1850 C300,1650 750,2000 1200,1800" fill="none" stroke="#E2E8F0" stroke-width="8" stroke-dasharray="24 24" opacity="0.65"/>
        <!-- Soft subtle amber and blue ambient accents -->
        <circle cx="950" cy="180" r="300" fill="#FEF3C7" opacity="0.45" filter="blur(80px)"/>
        <circle cx="100" cy="2250" r="350" fill="#E0F2FE" opacity="0.5" filter="blur(90px)"/>
    </svg>
    """

def build_status_bar():
    return """
    <div class="status-bar">
        <span>9:41</span>
        <div class="camera-punch"></div>
        <div class="status-icons">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12 3c-4.97 0-9 4.03-9 9 0 2.12.74 4.07 1.97 5.61L12 22l7.03-4.39C20.26 16.07 21 14.12 21 12c0-4.97-4.03-9-9-9zm0 16.5l-4.5-2.81C6.58 15.48 6 13.82 6 12c0-3.31 2.69-6 6-6s6 2.69 6 6c0 1.82-.58 3.48-1.5 4.69L12 19.5z"/>
            </svg>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12 4C7.31 4 3.07 5.9 0 8.98L12 21 24 8.98C20.93 5.9 16.69 4 12 4z"/>
            </svg>
            <svg width="24" height="20" viewBox="0 0 24 24" fill="currentColor">
                <path d="M17 4h-3V2h-4v2H7v18h10V4zm-2 16H9V6h6v14z"/>
            </svg>
        </div>
    </div>
    """

def build_bottom_nav(active_idx=0):
    items = [
        ("Home", '<path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/>'),
        ("Practice", '<path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>'),
        ("Mock Exam", '<path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm.5-13H11v6l5.25 3.15.75-1.23-4.5-2.67z"/>'),
        ("Road Signs", '<path d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.21.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99zM6.5 16c-.83 0-1.5-.67-1.5-1.5S5.67 13 6.5 13s1.5.67 1.5 1.5S7.33 16 6.5 16zm11 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zM5 11l1.5-4.5h11L19 11H5z"/>'),
        ("Progress", '<path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>')
    ]
    html = '<div class="bottom-nav">'
    for i, (name, svg_path) in enumerate(items):
        active_class = "active" if i == active_idx else ""
        fill_color = "#0284C7" if i == active_idx else "#94A3B8"
        html += f"""
        <div class="nav-item {active_class}">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="{fill_color}">
                {svg_path}
            </svg>
            <span>{name}</span>
        </div>
        """
    html += '</div>'
    return html

def render_html_to_png(html_content, out_png):
    temp_html = out_png.replace('.png', '.html')
    with open(temp_html, 'w', encoding='utf-8') as f:
        f.write(html_content)
    
    cmd = [
        CHROME_PATH,
        '--headless=new',
        '--disable-gpu',
        '--no-sandbox',
        '--hide-scrollbars',
        '--window-size=1080,2400',
        f'--screenshot={out_png}',
        temp_html
    ]
    res = subprocess.run(cmd, capture_output=True, text=True)
    print(f"Generated: {out_png} (Return code: {res.returncode})")
    if os.path.exists(temp_html):
        os.remove(temp_html)


# ==========================================
# SCREENSHOT 1: HOME DASHBOARD (LIGHT THEME)
# ==========================================
def build_screenshot_1():
    content = f"""<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
    {get_base_css()}
</style>
</head>
<body>
    {get_svg_road_backdrop()}
    
    <div class="header-area">
        <div class="brand-pill">🇵🇭 LTO EXAM COACH PHILIPPINES</div>
        <h1 class="headline">Prepare for Your <span class="gold">LTO Exam</span></h1>
        <p class="subtext">Practice questions, mock exams and road signs</p>
    </div>
    
    <div class="phone-container">
        {build_status_bar()}
        
        <div class="app-screen">
            <!-- App Bar -->
            <div class="app-bar">
                <div class="app-bar-brand">
                    <div class="app-bar-icon">
                        <svg width="28" height="28" viewBox="0 0 24 24" fill="#0284C7">
                            <path d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.21.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99zM6.5 16c-.83 0-1.5-.67-1.5-1.5S5.67 13 6.5 13s1.5.67 1.5 1.5S7.33 16 6.5 16zm11 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zM5 11l1.5-4.5h11L19 11H5z"/>
                        </svg>
                    </div>
                    <div>
                        <div class="app-bar-title">LTO Exam Coach</div>
                        <div class="app-bar-subtitle">Philippines Driver's License Reviewer</div>
                    </div>
                </div>
                <div style="color: #64748B;">
                    <svg width="26" height="26" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M19.14 12.94c.04-.3.06-.61.06-.94 0-.32-.02-.64-.07-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94l-.36-2.54c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.57-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58c-.05.3-.09.63-.09.94s.02.64.07.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32c.12.22.37.29.59.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .44-.17.47-.41l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.22.07-.47-.12-.61l-2.01-1.58zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6z"/>
                    </svg>
                </div>
            </div>
            
            <div class="app-scroll-content">
                <!-- User Greeting & Vehicle Mode -->
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <div style="font-size: 28px; font-weight: 800; color: #0F172A; letter-spacing: -0.3px;">Ready to practice?</div>
                        <div style="font-size: 15px; color: #64748B; margin-top: 3px;">Philippines Driver's License Reviewer</div>
                    </div>
                    <div style="display: flex; align-items: center; gap: 8px; background: #E0F2FE; border: 1.5px solid #BAE6FD; padding: 9px 18px; border-radius: 20px; font-size: 15px; font-weight: 700; color: #0284C7;">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.21.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99zM6.5 16c-.83 0-1.5-.67-1.5-1.5S5.67 13 6.5 13s1.5.67 1.5 1.5S7.33 16 6.5 16zm11 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zM5 11l1.5-4.5h11L19 11H5z"/></svg>
                        Non-Professional
                    </div>
                </div>
                
                <!-- Hero Card: Continue Practice -->
                <div class="hero-card" style="padding: 26px 28px;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                        <span class="pill-tag pill-blue">DAILY STUDY</span>
                        <span style="font-size: 17px; font-weight: 800; color: #0284C7;">36% Covered</span>
                    </div>
                    <div style="font-size: 28px; font-weight: 800; color: #0F172A;">Continue Practice</div>
                    <div style="font-size: 16px; color: #64748B; margin-top: 4px;">96 Questions Left to Review in Question Bank</div>
                    <div class="progress-bar-bg" style="margin: 18px 0 20px 0; height: 14px;">
                        <div class="progress-bar-fill" style="width: 36%;"></div>
                    </div>
                    <button class="btn-primary" style="width: 100%; padding: 20px;">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor"><path d="M8 5v14l11-7z"/></svg>
                        Start Practice
                    </button>
                </div>

                <!-- Daily Goal Card -->
                <div class="custom-card" style="padding: 18px 24px; background: #F0F9FF; border-color: #BAE6FD; display: flex; align-items: center; justify-content: space-between;">
                    <div style="display: flex; align-items: center; gap: 14px;">
                        <div style="font-size: 30px;">🎯</div>
                        <div>
                            <div style="font-size: 18px; font-weight: 800; color: #0F172A;">Today's Goal: 20 Questions</div>
                            <div style="font-size: 14px; color: #0369A1; font-weight: 600; margin-top: 2px;">14 / 20 Completed • 🔥 6 more to keep your 5-day streak!</div>
                        </div>
                    </div>
                    <span style="font-size: 18px; font-weight: 900; color: #15803D;">70%</span>
                </div>
                
                <!-- Study Stats Row -->
                <div class="stats-row">
                    <div class="stat-card" style="padding: 22px 14px;">
                        <div class="stat-value" style="color: #15803D;">54</div>
                        <div class="stat-label">Mastered</div>
                    </div>
                    <div class="stat-card" style="padding: 22px 14px;">
                        <div class="stat-value" style="color: #0284C7;">82%</div>
                        <div class="stat-label">Success Rate</div>
                    </div>
                    <div class="stat-card" style="padding: 22px 14px;">
                        <div class="stat-value" style="color: #7E22CE;">4</div>
                        <div class="stat-label">Mock Exams</div>
                    </div>
                </div>
                
                <!-- Quick Actions Grid -->
                <div class="quick-grid">
                    <div class="action-tile" style="padding: 22px 24px;">
                        <div class="tile-top">
                            <div class="tile-icon" style="background: #F3E8FF; color: #7E22CE;">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor"><path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm.5-13H11v6l5.25 3.15.75-1.23-4.5-2.67z"/></svg>
                            </div>
                            <span class="pill-tag pill-purple">Timed</span>
                        </div>
                        <div class="tile-title">Mock Exam</div>
                        <div class="tile-subtitle">60-question simulation</div>
                    </div>
                    <div class="action-tile" style="padding: 22px 24px;">
                        <div class="tile-top">
                            <div class="tile-icon" style="background: #FEF3C7; color: #B45309;">
                                <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2L1 21h22L12 2zm0 3.99L19.53 19H4.47L12 5.99zM11 10h2v4h-2zm0 6h2v2h-2z"/></svg>
                            </div>
                            <span class="pill-tag pill-amber">94 Signs</span>
                        </div>
                        <div class="tile-title">Road Signs</div>
                        <div class="tile-subtitle">Visual sign catalog</div>
                    </div>
                    <div class="action-tile" style="padding: 22px 24px;">
                        <div class="tile-top">
                            <div class="tile-icon" style="background: #FEE2E2; color: #B91C1C;">
                                <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg>
                            </div>
                            <span class="pill-tag pill-red">18 to Review</span>
                        </div>
                        <div class="tile-title">Wrong Answers</div>
                        <div class="tile-subtitle">Review mistakes</div>
                    </div>
                    <div class="action-tile" style="padding: 22px 24px;">
                        <div class="tile-top">
                            <div class="tile-icon" style="background: #FEF3C7; color: #B45309;">
                                <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor"><path d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/></svg>
                            </div>
                            <span class="pill-tag pill-amber">12 Saved</span>
                        </div>
                        <div class="tile-title">Difficult Items</div>
                        <div class="tile-subtitle">Target weak spots</div>
                    </div>
                </div>
                
                <!-- Topic Mastery Progress Overview -->
                <div class="custom-card" style="padding: 22px 26px;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px;">
                        <div style="font-size: 18px; font-weight: 800; color: #0F172A;">Study Mastery by Topic</div>
                        <span style="font-size: 14px; font-weight: 700; color: #0284C7;">View All</span>
                    </div>
                    
                    <div style="display: flex; flex-direction: column; gap: 12px;">
                        <div>
                            <div style="display: flex; justify-content: space-between; font-size: 15px; color: #475569; margin-bottom: 6px;">
                                <span>Traffic Rules & Regulations</span>
                                <span style="font-weight: 800; color: #15803D;">88%</span>
                            </div>
                            <div class="progress-bar-bg" style="height: 10px;"><div class="progress-bar-fill" style="width: 88%; background: #15803D;"></div></div>
                        </div>
                        <div>
                            <div style="display: flex; justify-content: space-between; font-size: 15px; color: #475569; margin-bottom: 6px;">
                                <span>Road Signs & Pavement Markings</span>
                                <span style="font-weight: 800; color: #15803D;">92%</span>
                            </div>
                            <div class="progress-bar-bg" style="height: 10px;"><div class="progress-bar-fill" style="width: 92%; background: #15803D;"></div></div>
                        </div>
                        <div>
                            <div style="display: flex; justify-content: space-between; font-size: 15px; color: #475569; margin-bottom: 6px;">
                                <span>Defensive Driving & Emergencies</span>
                                <span style="font-weight: 800; color: #15803D;">82%</span>
                            </div>
                            <div class="progress-bar-bg" style="height: 10px;"><div class="progress-bar-fill" style="width: 82%; background: #15803D;"></div></div>
                        </div>
                        <div>
                            <div style="display: flex; justify-content: space-between; font-size: 15px; color: #475569; margin-bottom: 6px;">
                                <span>Vehicle Safety & Inspection</span>
                                <span style="font-weight: 800; color: #D97706;">76%</span>
                            </div>
                            <div class="progress-bar-bg" style="height: 10px;"><div class="progress-bar-fill" style="width: 76%; background: #D97706;"></div></div>
                        </div>
                    </div>
                </div>

                <!-- Latest Mock Exam Card -->
                <div class="custom-card" style="background: #F0FDF4; border-color: #BBF7D0; padding: 20px 26px;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                        <span class="pill-tag pill-green">LATEST MOCK EXAM</span>
                        <span style="font-size: 15px; font-weight: 800; color: #15803D;">PASSED</span>
                    </div>
                    <div style="display: flex; justify-content: space-between; align-items: baseline;">
                        <div style="font-size: 30px; font-weight: 900; color: #0F172A;">52 / 60 <span style="font-size: 22px; color: #15803D; font-weight: 800;">(86.7%)</span></div>
                        <div style="font-size: 14px; color: #64748B;">32 mins used • Passing mark: 48/60</div>
                    </div>
                </div>

                <!-- Daily Tip Card -->
                <div class="custom-card" style="background: #FFFBEB; border-left: 6px solid #D97706; padding: 22px 26px;">
                    <div style="display: flex; align-items: center; gap: 10px; font-size: 15px; font-weight: 800; color: #B45309; margin-bottom: 6px;">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M9 21c0 .55.45 1 1 1h4c.55 0 1-.45 1-1v-1H9v1zm3-19C8.14 2 5 5.14 5 9c0 2.38 1.19 4.47 3 5.74V17c0 .55.45 1 1 1h6c.55 0 1-.45 1-1v-2.26c1.81-1.27 3-3.36 3-5.74 0-3.86-3.14-7-7-7z"/></svg>
                        DAILY DRIVING TIP • DEFENSIVE DRIVING
                    </div>
                    <div style="font-size: 16px; color: #334155; line-height: 1.5;">
                        Always maintain at least a <strong>3-second following distance</strong> behind the vehicle in front under normal road conditions. Double it during wet weather.
                    </div>
                </div>
                
                <!-- Legal Disclaimer -->
                <div style="font-size: 13px; color: #94A3B8; text-align: center; padding: 4px 0;">
                    Independent educational practice reviewer. Not affiliated with LTO, DOTr, or Philippine Government.
                </div>
            </div>
            
            {build_bottom_nav(0)}
        </div>
    </div>
</body>
</html>"""
    out_file = os.path.join(OUT_DIR, 'screenshot_1_home.png')
    render_html_to_png(content, out_file)


# ==========================================
# SCREENSHOT 2: PRACTICE QUIZ (LIGHT THEME)
# ==========================================
def build_screenshot_2():
    content = f"""<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
    {get_base_css()}
    
    .option-tile {{
        background: #FFFFFF;
        border: 2px solid #E2E8F0;
        border-radius: 20px;
        padding: 24px 28px;
        display: flex;
        align-items: center;
        gap: 20px;
        margin-bottom: 14px;
        box-shadow: 0 2px 6px rgba(15, 23, 42, 0.03);
    }}
    
    .option-tile.correct {{
        background: #F0FDF4;
        border-color: #22C55E;
        box-shadow: 0 4px 16px rgba(34, 197, 94, 0.15);
    }}
    
    .option-badge {{
        width: 52px;
        height: 52px;
        border-radius: 14px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 900;
        font-size: 22px;
        flex-shrink: 0;
    }}
    
    .option-badge.normal {{
        background: #E0F2FE;
        color: #0369A1;
    }}
    
    .option-badge.correct {{
        background: #22C55E;
        color: #FFFFFF;
    }}
    
    .explanation-card {{
        background: #F0FDF4;
        border: 2px solid #86EFAC;
        border-radius: 22px;
        padding: 26px 30px;
    }}
</style>
</head>
<body>
    {get_svg_road_backdrop()}
    
    <div class="header-area">
        <div class="brand-pill">🇵🇭 LTO EXAM COACH PHILIPPINES</div>
        <h1 class="headline">Practice With <span class="blue">150 Questions</span></h1>
        <p class="subtext">Learn from every answer with instant feedback</p>
    </div>
    
    <div class="phone-container">
        {build_status_bar()}
        
        <div class="app-screen">
            <!-- App Bar -->
            <div class="app-bar">
                <div style="display: flex; align-items: center; gap: 16px;">
                    <svg width="28" height="28" viewBox="0 0 24 24" fill="#64748B"><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg>
                    <div class="app-bar-title">Traffic Rules & Regulations</div>
                </div>
                <div style="display: flex; align-items: center; gap: 18px; color: #64748B;">
                    <svg width="26" height="26" viewBox="0 0 24 24" fill="#EF4444"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>
                    <svg width="26" height="26" viewBox="0 0 24 24" fill="#D97706"><path d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/></svg>
                </div>
            </div>
            
            <!-- Question Progress Line -->
            <div class="progress-bar-bg" style="height: 6px; border-radius: 0; flex-shrink: 0;">
                <div class="progress-bar-fill" style="width: 28%; height: 6px; border-radius: 0;"></div>
            </div>
            
            <div class="app-scroll-content">
                <!-- Question Meta Header -->
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <span style="font-size: 20px; font-weight: 800; color: #64748B;">Question 14 of 150</span>
                    <div style="display: flex; gap: 10px;">
                        <span class="pill-tag pill-blue">EASY</span>
                        <span class="pill-tag pill-amber">RA 4136</span>
                    </div>
                </div>

                <!-- Session Stats Strip -->
                <div style="display: flex; justify-content: space-between; align-items: center; background: #FFFFFF; border: 1.5px solid #E2E8F0; border-radius: 14px; padding: 14px 22px;">
                    <div style="display: flex; align-items: center; gap: 10px; font-size: 16px; color: #334155;">
                        <span style="color: #15803D; font-weight: 800;">● 13 Correct</span>
                        <span style="color: #94A3B8;">•</span>
                        <span style="color: #DC2626; font-weight: 700;">● 1 Review</span>
                    </div>
                    <div style="font-size: 16px; font-weight: 800; color: #0284C7;">🔥 8 Streak in a row</div>
                </div>
                
                <!-- Question Text Card -->
                <div class="custom-card" style="padding: 28px 32px; border-color: #BAE6FD;">
                    <div style="font-size: 26px; font-weight: 800; color: #0F172A; line-height: 1.45;">
                        Under Philippine traffic law (RA 4136), what does a flashing red traffic light indicate at an intersection?
                    </div>
                </div>
                
                <!-- Answer Choices List -->
                <div>
                    <div class="option-tile">
                        <div class="option-badge normal">A</div>
                        <div style="font-size: 20px; color: #334155; line-height: 1.4;">Slow down and proceed with caution without stopping</div>
                    </div>
                    
                    <div class="option-tile correct">
                        <div class="option-badge correct">B</div>
                        <div style="font-size: 20px; font-weight: 800; color: #0F172A; line-height: 1.4; flex: 1;">
                            Come to a complete stop, yield to cross traffic and pedestrians, then proceed when safe
                        </div>
                        <div style="color: #22C55E; flex-shrink: 0;">
                            <svg width="34" height="34" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>
                        </div>
                    </div>
                    
                    <div class="option-tile">
                        <div class="option-badge normal">C</div>
                        <div style="font-size: 20px; color: #334155; line-height: 1.4;">Stop and wait until the light turns solid green</div>
                    </div>
                    
                    <div class="option-tile" style="margin-bottom: 0;">
                        <div class="option-badge normal">D</div>
                        <div style="font-size: 20px; color: #334155; line-height: 1.4;">Speed up to clear the intersection quickly</div>
                    </div>
                </div>
                
                <!-- Instant Feedback & Explanation Card -->
                <div class="explanation-card">
                    <div style="display: flex; align-items: center; gap: 12px; color: #15803D; font-weight: 900; font-size: 22px; margin-bottom: 10px;">
                        <svg width="28" height="28" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>
                        Correct Answer Rationale
                    </div>
                    <div style="font-size: 18px; color: #1E293B; line-height: 1.52;">
                        A flashing red light operates exactly like an octagonal STOP sign. Drivers must make a complete stop before the stop line, yield to approaching traffic and pedestrians, and proceed only when clear.
                    </div>
                    <div style="font-size: 15px; color: #64748B; font-style: italic; margin-top: 10px;">
                        Reference: RA 4136, Section 35 & DPWH Traffic Signal Guidelines
                    </div>
                </div>

                <!-- Exam Tip Card -->
                <div class="custom-card" style="background: #FFFBEB; border-color: #FDE68A; padding: 20px 26px;">
                    <div style="display: flex; align-items: center; gap: 10px; color: #B45309; font-weight: 800; font-size: 16px; margin-bottom: 6px;">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor"><path d="M9 21c0 .55.45 1 1 1h4c.55 0 1-.45 1-1v-1H9v1zm3-19C8.14 2 5 5.14 5 9c0 2.38 1.19 4.47 3 5.74V17c0 .55.45 1 1 1h6c.55 0 1-.45 1-1v-2.26c1.81-1.27 3-3.36 3-5.74 0-3.86-3.14-7-7-7z"/></svg>
                        LTO EXAM TIP • FREQUENTLY TESTED
                    </div>
                    <div style="font-size: 16px; color: #334155; line-height: 1.48;">
                        Flashing Red = Full Stop then yield; Flashing Yellow = Slow Down and proceed with caution.
                    </div>
                </div>

                <!-- Right of Way Concept Card -->
                <div class="custom-card" style="background: #F0F9FF; border-left: 6px solid #0284C7; padding: 18px 24px;">
                    <div style="font-size: 15px; font-weight: 800; color: #0284C7; margin-bottom: 4px;">RIGHT-OF-WAY CONCEPT • RA 4136 SEC. 35</div>
                    <div style="font-size: 15px; color: #334155; line-height: 1.48;">
                        Vehicles already inside an intersection or traveling on through-highways have right of way over vehicles entering from side roads.
                    </div>
                </div>

                <!-- Question Insights & Pass Rate Card -->
                <div class="custom-card" style="background: #FFFFFF; border-color: #E2E8F0; padding: 18px 24px; display: flex; align-items: center; justify-content: space-between;">
                    <div style="display: flex; align-items: center; gap: 14px;">
                        <span style="font-size: 28px;">📊</span>
                        <div>
                            <div style="font-size: 16px; font-weight: 800; color: #0F172A;">Question Pass Rate: 74%</div>
                            <div style="font-size: 14px; color: #0284C7;">Common trap: 22% confuse flashing red with flashing yellow</div>
                        </div>
                    </div>
                    <span class="pill-tag pill-green">High Yield</span>
                </div>

                <!-- Review Bookmark Pill -->
                <div style="display: flex; justify-content: space-between; align-items: center; padding: 4px 6px;">
                    <div style="display: flex; align-items: center; gap: 8px; color: #0284C7; font-size: 15px; font-weight: 700;">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>
                        Saved to Review List (18 items bookmarked)
                    </div>
                    <span style="font-size: 14px; color: #64748B;">Topic: Right of Way & Signals</span>
                </div>
            </div>
            
            <!-- Bottom Quiz Action Bar -->
            <div style="padding: 22px 28px; border-top: 1.5px solid #E2E8F0; background: #FFFFFF; display: flex; gap: 16px; align-items: center; flex-shrink: 0;">
                <button class="btn-secondary" style="flex: 1; padding: 20px; font-size: 19px;">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="#EF4444"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>
                    Flag Question
                </button>
                <button class="btn-primary" style="flex: 1.6; padding: 20px; font-size: 21px;">
                    Next Question
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor"><path d="M12 4l-1.41 1.41L16.17 11H4v2h12.17l-5.58 5.59L12 20l8-8z"/></svg>
                </button>
            </div>
        </div>
    </div>
</body>
</html>"""
    out_file = os.path.join(OUT_DIR, 'screenshot_2_practice.png')
    render_html_to_png(content, out_file)


# ==========================================
# SCREENSHOT 3: MOCK EXAM (LIGHT THEME)
# ==========================================
def build_screenshot_3():
    content = f"""<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
    {get_base_css()}
    
    .timer-badge {{
        background: #FEF3C7;
        border: 1.5px solid #FCD34D;
        padding: 9px 20px;
        border-radius: 24px;
        display: flex;
        align-items: center;
        gap: 10px;
        font-weight: 800;
        font-size: 18px;
        color: #B45309;
    }}
    
    .timer-dot {{
        width: 12px;
        height: 12px;
        background: #D97706;
        border-radius: 50%;
    }}
    
    .option-tile-mock {{
        background: #FFFFFF;
        border: 2px solid #E2E8F0;
        border-radius: 18px;
        padding: 20px 24px;
        display: flex;
        align-items: center;
        gap: 16px;
        margin-bottom: 12px;
        box-shadow: 0 2px 6px rgba(15, 23, 42, 0.03);
    }}
    
    .option-tile-mock.selected {{
        background: #F0F9FF;
        border-color: #0284C7;
    }}
    
    .result-overlay-card {{
        background: #FFFFFF;
        border: 2px solid #86EFAC;
        border-radius: 24px;
        padding: 26px 28px;
        box-shadow: 0 8px 24px rgba(15, 23, 42, 0.06);
    }}

    .nav-grid-dots {{
        display: grid;
        grid-template-columns: repeat(12, 1fr);
        gap: 8px;
        margin-top: 12px;
    }}

    .nav-dot {{
        height: 18px;
        border-radius: 5px;
        background: #E2E8F0;
    }}

    .nav-dot.done {{
        background: #22C55E;
    }}

    .nav-dot.current {{
        background: #0284C7;
        box-shadow: 0 0 6px rgba(2, 132, 199, 0.5);
    }}

    .nav-dot.flagged {{
        background: #F59E0B;
    }}
</style>
</head>
<body>
    {get_svg_road_backdrop()}
    
    <div class="header-area">
        <div class="brand-pill">🇵🇭 LTO EXAM COACH PHILIPPINES</div>
        <h1 class="headline">Test Yourself With <span class="gold">Mock Exams</span></h1>
        <p class="subtext">Timed practice with detailed results</p>
    </div>
    
    <div class="phone-container">
        {build_status_bar()}
        
        <div class="app-screen">
            <!-- App Bar -->
            <div class="app-bar">
                <div style="display: flex; align-items: center; gap: 14px;">
                    <div class="app-bar-title">Mock Exam • Non-Professional</div>
                </div>
                <div style="display: flex; align-items: center; gap: 14px;">
                    <div class="timer-badge">
                        <div class="timer-dot"></div>
                        48:22 Left
                    </div>
                </div>
            </div>
            
            <!-- Progress Line -->
            <div class="progress-bar-bg" style="height: 6px; border-radius: 0; flex-shrink: 0;">
                <div class="progress-bar-fill" style="width: 40%; height: 6px; border-radius: 0; background: #D97706;"></div>
            </div>
            
            <div class="app-scroll-content">
                <!-- Status Row -->
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <span style="font-size: 20px; font-weight: 800; color: #64748B;">Question 24 of 60</span>
                    <div style="display: flex; align-items: center; gap: 8px; background: #F1F5F9; border: 1px solid #CBD5E1; padding: 8px 16px; border-radius: 10px; font-size: 15px; font-weight: 700; color: #334155;">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="#D97706"><path d="M14.4 6L14 4H5v17h2v-7h5.6l.4 2h7V6z"/></svg>
                        Flag for Review
                    </div>
                </div>
                
                <!-- Mock Question Card -->
                <div class="custom-card" style="padding: 26px 28px; border-color: #FCD34D;">
                    <div style="font-size: 24px; font-weight: 800; color: #0F172A; line-height: 1.45;">
                        Under RA 4136, what is the maximum allowable speed limit for passenger cars and motorcycles on open country roads with no blind corners?
                    </div>
                </div>
                
                <!-- Mock Options -->
                <div>
                    <div class="option-tile-mock">
                        <div class="option-badge normal" style="font-size: 19px; width: 44px; height: 44px;">A</div>
                        <div style="font-size: 19px; color: #334155;">60 km/h</div>
                    </div>
                    <div class="option-tile-mock selected">
                        <div class="option-badge" style="background: #0284C7; color: #FFFFFF; font-size: 19px; width: 44px; height: 44px;">B</div>
                        <div style="font-size: 19px; font-weight: 800; color: #0F172A; flex: 1;">80 km/h</div>
                        <svg width="26" height="26" viewBox="0 0 24 24" fill="#0284C7"><circle cx="12" cy="12" r="10" stroke="#0284C7" stroke-width="2" fill="none"/><circle cx="12" cy="12" r="5" fill="#0284C7"/></svg>
                    </div>
                    <div class="option-tile-mock">
                        <div class="option-badge normal" style="font-size: 19px; width: 44px; height: 44px;">C</div>
                        <div style="font-size: 19px; color: #334155;">100 km/h</div>
                    </div>
                    <div class="option-tile-mock" style="margin-bottom: 0;">
                        <div class="option-badge normal" style="font-size: 19px; width: 44px; height: 44px;">D</div>
                        <div style="font-size: 19px; color: #334155;">50 km/h</div>
                    </div>
                </div>

                <!-- Quick Exam Navigator Matrix -->
                <div class="custom-card" style="padding: 20px 24px;">
                    <div style="display: flex; justify-content: space-between; font-size: 15px; color: #64748B;">
                        <span>Exam Navigator (24 / 60 Answered)</span>
                        <span style="color: #D97706; font-weight: 700;">2 Flagged for Review</span>
                    </div>
                    <div class="nav-grid-dots">
                        <div class="nav-dot done"></div><div class="nav-dot done"></div><div class="nav-dot done"></div><div class="nav-dot done"></div>
                        <div class="nav-dot done"></div><div class="nav-dot done"></div><div class="nav-dot done"></div><div class="nav-dot done"></div>
                        <div class="nav-dot done"></div><div class="nav-dot flagged"></div><div class="nav-dot done"></div><div class="nav-dot done"></div>
                        <div class="nav-dot done"></div><div class="nav-dot done"></div><div class="nav-dot done"></div><div class="nav-dot done"></div>
                        <div class="nav-dot done"></div><div class="nav-dot done"></div><div class="nav-dot flagged"></div><div class="nav-dot done"></div>
                        <div class="nav-dot done"></div><div class="nav-dot done"></div><div class="nav-dot done"></div><div class="nav-dot current"></div>
                        <div class="nav-dot"></div><div class="nav-dot"></div><div class="nav-dot"></div><div class="nav-dot"></div>
                        <div class="nav-dot"></div><div class="nav-dot"></div><div class="nav-dot"></div><div class="nav-dot"></div>
                        <div class="nav-dot"></div><div class="nav-dot"></div><div class="nav-dot"></div><div class="nav-dot"></div>
                    </div>
                </div>
                
                <!-- Detailed Mock Result Card -->
                <div class="result-overlay-card" style="padding: 26px 28px;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                        <span class="pill-tag pill-green" style="font-size: 14px;">OFFICIAL SIMULATION • PASSED</span>
                        <span style="font-size: 14px; color: #64748B; font-weight: 700;">Passing: 48/60 (80%)</span>
                    </div>
                    <div style="display: flex; justify-content: space-between; align-items: baseline;">
                        <div style="font-size: 46px; font-weight: 900; color: #15803D; letter-spacing: -1px;">52 / 60</div>
                        <div style="font-size: 32px; font-weight: 800; color: #0F172A;">86.7%</div>
                    </div>
                    <div style="font-size: 14px; color: #64748B; margin-top: 4px;">Time Used: 32 mins • Completed with 16 mins remaining</div>
                    
                    <!-- Topic Mastery Breakdown -->
                    <div style="margin-top: 14px; display: flex; flex-direction: column; gap: 8px;">
                        <div>
                            <div style="display: flex; justify-content: space-between; font-size: 14px; color: #334155; margin-bottom: 4px;">
                                <span>Road Rules & Law</span>
                                <span style="font-weight: 800; color: #15803D;">90%</span>
                            </div>
                            <div class="progress-bar-bg" style="height: 8px;">
                                <div class="progress-bar-fill" style="width: 90%; background: #15803D;"></div>
                            </div>
                        </div>
                        <div>
                            <div style="display: flex; justify-content: space-between; font-size: 14px; color: #334155; margin-bottom: 4px;">
                                <span>Traffic Signs & Signals</span>
                                <span style="font-weight: 800; color: #15803D;">93%</span>
                            </div>
                            <div class="progress-bar-bg" style="height: 8px;">
                                <div class="progress-bar-fill" style="width: 93%; background: #15803D;"></div>
                            </div>
                        </div>
                        <div>
                            <div style="display: flex; justify-content: space-between; font-size: 14px; color: #334155; margin-bottom: 4px;">
                                <span>Defensive Driving & Safety</span>
                                <span style="font-weight: 800; color: #D97706;">80%</span>
                            </div>
                            <div class="progress-bar-bg" style="height: 8px;">
                                <div class="progress-bar-fill" style="width: 80%; background: #D97706;"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- RA 4136 Speed Limit Reference -->
                <div class="custom-card" style="background: #FFFBEB; border-left: 6px solid #D97706; padding: 18px 24px;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">
                        <span style="font-size: 15px; font-weight: 800; color: #B45309;">RA 4136 SPEED LIMIT STANDARD</span>
                        <span class="pill-tag pill-amber" style="font-size: 11px; padding: 3px 8px;">ARTICLE IV</span>
                    </div>
                    <div style="font-size: 14px; color: #334155; line-height: 1.48;">
                        Open country roads: <strong>80 km/h</strong> for cars/motorcycles, <strong>50 km/h</strong> for trucks/buses. City streets: <strong>30 km/h</strong> max.
                    </div>
                </div>

                <!-- Simulation Benchmark Note -->
                <div class="custom-card" style="background: #F0FDF4; border-left: 6px solid #15803D; padding: 18px 24px;">
                    <div style="font-size: 15px; font-weight: 800; color: #15803D; margin-bottom: 4px;">EXAM READINESS STATUS: QUALIFIED</div>
                    <div style="font-size: 14px; color: #334155; line-height: 1.45;">
                        Your score exceeds the official 80% passing mark. You are well prepared for the Land Transportation Office exam.
                    </div>
                </div>

                <!-- Timed Exam Strategy & Mode -->
                <div class="custom-card" style="background: #FFFFFF; border-color: #E2E8F0; padding: 16px 22px; display: flex; align-items: center; justify-content: space-between;">
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <span style="font-size: 24px;">⏱️</span>
                        <div>
                            <div style="font-size: 15px; font-weight: 800; color: #0F172A;">Exam Pace: Optimal (45s / question)</div>
                            <div style="font-size: 13px; color: #0284C7;">Projected completion with 16 mins remaining buffer</div>
                        </div>
                    </div>
                    <span class="pill-tag pill-blue" style="font-size: 11px; padding: 3px 8px;">On Track</span>
                </div>
            </div>
            
            <!-- Bottom Exam Actions Bar -->
            <div style="padding: 22px 28px; border-top: 1.5px solid #E2E8F0; background: #FFFFFF; display: flex; gap: 16px; flex-shrink: 0;">
                <button class="btn-secondary" style="flex: 1; font-size: 19px; padding: 20px;">Question Nav (24/60)</button>
                <button class="btn-primary" style="flex: 1.4; font-size: 21px; padding: 20px;">Submit Exam</button>
            </div>
        </div>
    </div>
</body>
</html>"""
    out_file = os.path.join(OUT_DIR, 'screenshot_3_mock_exam.png')
    render_html_to_png(content, out_file)


# ==========================================
# SCREENSHOT 4: ROAD SIGNS (LIGHT THEME)
# ==========================================
def build_screenshot_4():
    content = f"""<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
    {get_base_css()}
    
    .signs-grid {{
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 16px;
    }}
    
    .sign-card {{
        background: #FFFFFF;
        border: 1.5px solid #E2E8F0;
        border-radius: 18px;
        padding: 16px 14px;
        display: flex;
        flex-direction: column;
        align-items: center;
        text-align: center;
        gap: 8px;
        box-shadow: 0 2px 6px rgba(15, 23, 42, 0.04);
    }}
    
    .sign-preview {{
        width: 78px;
        height: 78px;
        display: flex;
        align-items: center;
        justify-content: center;
    }}
    
    .filter-chips-row {{
        display: flex;
        gap: 10px;
        overflow: hidden;
    }}
    
    .filter-chip {{
        padding: 9px 18px;
        border-radius: 20px;
        font-size: 14px;
        font-weight: 700;
        background: #FFFFFF;
        border: 1.5px solid #E2E8F0;
        color: #64748B;
        white-space: nowrap;
    }}
    
    .filter-chip.active {{
        background: #0284C7;
        color: #FFFFFF;
        border-color: #0284C7;
    }}
    
    .search-mock {{
        background: #FFFFFF;
        border: 1.5px solid #E2E8F0;
        border-radius: 16px;
        padding: 14px 20px;
        display: flex;
        align-items: center;
        gap: 12px;
        color: #94A3B8;
        font-size: 15px;
    }}
</style>
</head>
<body>
    {get_svg_road_backdrop()}
    
    <div class="header-area">
        <div class="brand-pill">🇵🇭 LTO EXAM COACH PHILIPPINES</div>
        <h1 class="headline">Learn Philippine <span class="gold">Road Signs</span></h1>
        <p class="subtext">Explore signs and test your knowledge</p>
    </div>
    
    <div class="phone-container">
        {build_status_bar()}
        
        <div class="app-screen">
            <!-- App Bar -->
            <div class="app-bar">
                <div class="app-bar-title">Road Signs</div>
                <div style="display: flex; align-items: center; gap: 8px; background: #E0F2FE; border: 1.5px solid #BAE6FD; padding: 9px 16px; border-radius: 18px; font-size: 14px; font-weight: 800; color: #0284C7;">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M12 3L1 9l4 2.18v6L12 21l7-3.82v-6l2-1.09V17h2V9L12 3zm6.82 6L12 12.72 5.18 9 12 5.28 18.82 9zM17 15.99l-5 2.73-5-2.73v-3.72L12 15l5-2.73v3.72z"/></svg>
                    Practice Signs
                </div>
            </div>
            
            <div class="app-scroll-content">
                <!-- Search Mockup -->
                <div class="search-mock">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="#94A3B8"><path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/></svg>
                    <span>Search signs by name, meaning, or category...</span>
                </div>
                
                <!-- Category Filter Chips -->
                <div class="filter-chips-row">
                    <div class="filter-chip active">All (94)</div>
                    <div class="filter-chip">Regulatory (32)</div>
                    <div class="filter-chip">Warning (28)</div>
                    <div class="filter-chip">Informative (18)</div>
                    <div class="filter-chip">Guide (16)</div>
                </div>
                
                <!-- Learn Mode Flashcard Banner -->
                <div class="custom-card" style="background: #F0F9FF; border: 1.5px solid #BAE6FD; padding: 18px 22px; display: flex; align-items: center; justify-content: space-between;">
                    <div style="display: flex; align-items: center; gap: 14px;">
                        <div style="width: 44px; height: 44px; border-radius: 12px; background: #0284C7; display: flex; align-items: center; justify-content: center; color: #FFFFFF;">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor"><path d="M12 3L1 9l4 2.18v6L12 21l7-3.82v-6l2-1.09V17h2V9L12 3zm6.82 6L12 12.72 5.18 9 12 5.28 18.82 9zM17 15.99l-5 2.73-5-2.73v-3.72L12 15l5-2.73v3.72z"/></svg>
                        </div>
                        <div>
                            <div style="font-size: 17px; font-weight: 800; color: #0F172A;">Learn Road Signs Mode</div>
                            <div style="font-size: 14px; color: #64748B;">Interactive 10-sign recognition flash quiz</div>
                        </div>
                    </div>
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="#0284C7"><path d="M8.59 16.59L13.17 12 8.59 7.41 10 6l6 6-6 6-1.41-1.41z"/></svg>
                </div>
                
                <!-- 12 Signs Grid (6 rows of 2) -->
                <div class="signs-grid">
                    <!-- Sign 1: STOP -->
                    <div class="sign-card">
                        <div class="sign-preview">
                            <svg width="74" height="74" viewBox="0 0 100 100">
                                <polygon points="30,5 70,5 95,30 95,70 70,95 30,95 5,70 5,30" fill="#E53935" stroke="#FFFFFF" stroke-width="4"/>
                                <text x="50" y="58" font-family="Arial, sans-serif" font-size="22" font-weight="900" fill="#FFFFFF" text-anchor="middle">STOP</text>
                            </svg>
                        </div>
                        <div style="font-size: 15px; font-weight: 800; color: #0F172A;">Stop Sign</div>
                        <span class="pill-tag pill-red" style="font-size: 11px; padding: 3px 8px;">Regulatory</span>
                    </div>
                    
                    <!-- Sign 2: YIELD -->
                    <div class="sign-card">
                        <div class="sign-preview">
                            <svg width="74" height="74" viewBox="0 0 100 100">
                                <polygon points="10,15 90,15 50,88" fill="#FFFFFF" stroke="#E53935" stroke-width="12"/>
                                <polygon points="26,24 74,24 50,70" fill="#E53935"/>
                            </svg>
                        </div>
                        <div style="font-size: 15px; font-weight: 800; color: #0F172A;">Give Way / Yield</div>
                        <span class="pill-tag pill-red" style="font-size: 11px; padding: 3px 8px;">Regulatory</span>
                    </div>
                    
                    <!-- Sign 3: NO ENTRY -->
                    <div class="sign-card">
                        <div class="sign-preview">
                            <svg width="74" height="74" viewBox="0 0 100 100">
                                <circle cx="50" cy="50" r="44" fill="#E53935"/>
                                <rect x="18" y="42" width="64" height="16" fill="#FFFFFF" rx="2"/>
                            </svg>
                        </div>
                        <div style="font-size: 15px; font-weight: 800; color: #0F172A;">No Entry</div>
                        <span class="pill-tag pill-red" style="font-size: 11px; padding: 3px 8px;">Regulatory</span>
                    </div>
                    
                    <!-- Sign 4: SPEED LIMIT 60 -->
                    <div class="sign-card">
                        <div class="sign-preview">
                            <svg width="74" height="74" viewBox="0 0 100 100">
                                <circle cx="50" cy="50" r="42" fill="#FFFFFF" stroke="#E53935" stroke-width="10"/>
                                <text x="50" y="60" font-family="Arial, sans-serif" font-size="32" font-weight="900" fill="#000000" text-anchor="middle">60</text>
                            </svg>
                        </div>
                        <div style="font-size: 15px; font-weight: 800; color: #0F172A;">Speed Limit 60</div>
                        <span class="pill-tag pill-red" style="font-size: 11px; padding: 3px 8px;">Regulatory</span>
                    </div>
                    
                    <!-- Sign 5: PEDESTRIAN CROSSING -->
                    <div class="sign-card">
                        <div class="sign-preview">
                            <svg width="74" height="74" viewBox="0 0 100 100">
                                <polygon points="50,6 94,50 50,94 6,50" fill="#F59E0B" stroke="#000000" stroke-width="3"/>
                                <circle cx="50" cy="32" r="5" fill="#000000"/>
                                <path d="M46 40 L54 40 L53 58 L49 58 L48 50 L45 58 L41 58 L44 45 Z" fill="#000000"/>
                                <line x1="32" y1="68" x2="68" y2="68" stroke="#000000" stroke-width="4"/>
                            </svg>
                        </div>
                        <div style="font-size: 15px; font-weight: 800; color: #0F172A;">Pedestrian Crossing</div>
                        <span class="pill-tag pill-amber" style="font-size: 11px; padding: 3px 8px;">Warning</span>
                    </div>
                    
                    <!-- Sign 6: CURVE TO RIGHT -->
                    <div class="sign-card">
                        <div class="sign-preview">
                            <svg width="74" height="74" viewBox="0 0 100 100">
                                <polygon points="50,6 94,50 50,94 6,50" fill="#F59E0B" stroke="#000000" stroke-width="3"/>
                                <path d="M42 66 L42 48 Q42 36 56 36 L64 36 M60 28 L72 36 L60 44" fill="none" stroke="#000000" stroke-width="6" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>
                        </div>
                        <div style="font-size: 15px; font-weight: 800; color: #0F172A;">Curve to Right</div>
                        <span class="pill-tag pill-amber" style="font-size: 11px; padding: 3px 8px;">Warning</span>
                    </div>

                    <!-- Sign 7: NO U-TURN -->
                    <div class="sign-card">
                        <div class="sign-preview">
                            <svg width="74" height="74" viewBox="0 0 100 100">
                                <circle cx="50" cy="50" r="42" fill="#FFFFFF" stroke="#E53935" stroke-width="10"/>
                                <path d="M38 64 V44 C38 34 62 34 62 44 V52" stroke="#000000" stroke-width="6" fill="none" stroke-linecap="round"/>
                                <polygon points="62,56 54,48 70,48" fill="#000000"/>
                                <line x1="22" y1="22" x2="78" y2="78" stroke="#E53935" stroke-width="8"/>
                            </svg>
                        </div>
                        <div style="font-size: 15px; font-weight: 800; color: #0F172A;">No U-Turn</div>
                        <span class="pill-tag pill-red" style="font-size: 11px; padding: 3px 8px;">Regulatory</span>
                    </div>

                    <!-- Sign 8: TRAFFIC LIGHT AHEAD -->
                    <div class="sign-card">
                        <div class="sign-preview">
                            <svg width="74" height="74" viewBox="0 0 100 100">
                                <polygon points="50,6 94,50 50,94 6,50" fill="#F59E0B" stroke="#000000" stroke-width="3"/>
                                <rect x="42" y="24" width="16" height="42" rx="4" fill="#000000"/>
                                <circle cx="50" cy="32" r="4" fill="#EF4444"/>
                                <circle cx="50" cy="45" r="4" fill="#F59E0B"/>
                                <circle cx="50" cy="58" r="4" fill="#22C55E"/>
                            </svg>
                        </div>
                        <div style="font-size: 15px; font-weight: 800; color: #0F172A;">Traffic Light Ahead</div>
                        <span class="pill-tag pill-amber" style="font-size: 11px; padding: 3px 8px;">Warning</span>
                    </div>

                    <!-- Sign 9: SLIPPERY ROAD -->
                    <div class="sign-card">
                        <div class="sign-preview">
                            <svg width="74" height="74" viewBox="0 0 100 100">
                                <polygon points="50,6 94,50 50,94 6,50" fill="#F59E0B" stroke="#000000" stroke-width="3"/>
                                <rect x="36" y="38" width="28" height="16" rx="4" fill="#000000"/>
                                <circle cx="42" cy="55" r="4" fill="#000000"/>
                                <circle cx="58" cy="55" r="4" fill="#000000"/>
                                <path d="M34 66 Q42 62 48 68 T66 66" fill="none" stroke="#000000" stroke-width="3"/>
                            </svg>
                        </div>
                        <div style="font-size: 15px; font-weight: 800; color: #0F172A;">Slippery Road</div>
                        <span class="pill-tag pill-amber" style="font-size: 11px; padding: 3px 8px;">Warning</span>
                    </div>

                    <!-- Sign 10: ROUNDABOUT AHEAD -->
                    <div class="sign-card">
                        <div class="sign-preview">
                            <svg width="74" height="74" viewBox="0 0 100 100">
                                <circle cx="50" cy="50" r="42" fill="#0284C7"/>
                                <circle cx="50" cy="50" r="24" fill="none" stroke="#FFFFFF" stroke-width="6" stroke-dasharray="24 16"/>
                                <polygon points="50,20 44,30 56,30" fill="#FFFFFF"/>
                            </svg>
                        </div>
                        <div style="font-size: 15px; font-weight: 800; color: #0F172A;">Roundabout</div>
                        <span class="pill-tag pill-blue" style="font-size: 11px; padding: 3px 8px;">Mandatory</span>
                    </div>

                    <!-- Sign 11: TWO-WAY TRAFFIC -->
                    <div class="sign-card">
                        <div class="sign-preview">
                            <svg width="74" height="74" viewBox="0 0 100 100">
                                <polygon points="50,6 94,50 50,94 6,50" fill="#F59E0B" stroke="#000000" stroke-width="3"/>
                                <path d="M40 70 L40 32 M34 40 L40 28 L46 40" fill="none" stroke="#000000" stroke-width="6" stroke-linecap="round" stroke-linejoin="round"/>
                                <path d="M60 30 L60 68 M54 60 L60 72 L66 60" fill="none" stroke="#000000" stroke-width="6" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>
                        </div>
                        <div style="font-size: 15px; font-weight: 800; color: #0F172A;">Two-Way Traffic</div>
                        <span class="pill-tag pill-amber" style="font-size: 11px; padding: 3px 8px;">Warning</span>
                    </div>

                    <!-- Sign 12: NO PARKING -->
                    <div class="sign-card">
                        <div class="sign-preview">
                            <svg width="74" height="74" viewBox="0 0 100 100">
                                <circle cx="50" cy="50" r="42" fill="#0284C7" stroke="#E53935" stroke-width="9"/>
                                <text x="50" y="62" font-family="Arial, sans-serif" font-size="38" font-weight="900" fill="#FFFFFF" text-anchor="middle">P</text>
                                <line x1="22" y1="22" x2="78" y2="78" stroke="#E53935" stroke-width="9"/>
                            </svg>
                        </div>
                        <div style="font-size: 15px; font-weight: 800; color: #0F172A;">No Parking</div>
                        <span class="pill-tag pill-red" style="font-size: 11px; padding: 3px 8px;">Regulatory</span>
                    </div>
                </div>

                <!-- Interactive Flashcard Preview (from road_sign_detail_screen) -->
                <div class="custom-card" style="background: #F0F9FF; border-left: 6px solid #0284C7; padding: 18px 24px;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">
                        <span style="font-size: 15px; font-weight: 800; color: #0284C7;">SIGN DETAIL • INTERACTIVE FLASHCARD</span>
                        <span class="pill-tag pill-red" style="font-size: 11px; padding: 3px 8px;">MANDATORY</span>
                    </div>
                    <div style="font-size: 14px; color: #334155; line-height: 1.48;">
                        Tap any sign to view legal definition, DPWH specifications, and related LTO exam practice questions.
                    </div>
                </div>

                <!-- DPWH Classification Guide -->
                <div class="custom-card" style="background: #FFFBEB; border-left: 6px solid #D97706; padding: 18px 24px;">
                    <div style="font-size: 15px; font-weight: 800; color: #B45309; margin-bottom: 4px;">DPWH ROAD SIGN STANDARDS</div>
                    <div style="font-size: 14px; color: #334155; line-height: 1.45;">
                        <strong>Regulatory (Red):</strong> Mandatory laws & prohibitions. <strong>Warning (Yellow):</strong> Road hazards & conditions ahead.
                    </div>
                </div>

                <!-- Legal Penalty Notice -->
                <div class="custom-card" style="background: #FEF2F2; border-color: #FECACA; padding: 16px 24px;">
                    <div style="font-size: 14px; font-weight: 800; color: #DC2626; margin-bottom: 4px;">OFFICIAL LTO PENALTY PROVISION • JAO 2014-01</div>
                    <div style="font-size: 13px; color: #475569; line-height: 1.42;">
                        Failure to obey regulatory traffic signs carries an administrative fine of ₱1,000 for the first offense and demerit points on your driver's license record.
                    </div>
                </div>

                <!-- Footer Summary Bar -->
                <div style="display: flex; justify-content: space-between; align-items: center; background: #FFFFFF; border: 1.5px solid #E2E8F0; border-radius: 14px; padding: 14px 20px;">
                    <span style="font-size: 15px; color: #64748B;">Showing <strong>12 of 94</strong> Road Signs</span>
                    <span style="font-size: 15px; color: #0284C7; font-weight: 700;">DPWH & LTO Compliant</span>
                </div>
            </div>
            
            {build_bottom_nav(3)}
        </div>
    </div>
</body>
</html>"""
    out_file = os.path.join(OUT_DIR, 'screenshot_4_road_signs.png')
    render_html_to_png(content, out_file)


# ==========================================
# SCREENSHOT 5: PROGRESS & ANALYTICS (LIGHT THEME)
# ==========================================
def build_screenshot_5():
    content = f"""<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
    {get_base_css()}
    
    .streak-card {{
        background: #FFFBEB;
        border: 2px solid #FDE68A;
        border-radius: 22px;
        padding: 24px 26px;
    }}
    
    .days-row {{
        display: flex;
        justify-content: space-between;
        margin-top: 16px;
    }}
    
    .day-pill {{
        width: 46px;
        height: 46px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 16px;
        font-weight: 800;
    }}
    
    .day-pill.done {{
        background: #D97706;
        color: #FFFFFF;
    }}
    
    .day-pill.pending {{
        background: #F1F5F9;
        color: #94A3B8;
    }}
    
    .cat-bar-item {{
        display: flex;
        flex-direction: column;
        gap: 6px;
        margin-bottom: 12px;
    }}
</style>
</head>
<body>
    {get_svg_road_backdrop()}
    
    <div class="header-area">
        <div class="brand-pill">🇵🇭 LTO EXAM COACH PHILIPPINES</div>
        <h1 class="headline">Track Your <span class="blue">Progress</span></h1>
        <p class="subtext">Review your practice and improve your weak areas</p>
    </div>
    
    <div class="phone-container">
        {build_status_bar()}
        
        <div class="app-screen">
            <!-- App Bar -->
            <div class="app-bar">
                <div class="app-bar-title">Your Progress</div>
                <div style="font-size: 14px; font-weight: 700; color: #0284C7; background: #E0F2FE; border: 1.5px solid #BAE6FD; padding: 8px 16px; border-radius: 16px;">
                    Summary View
                </div>
            </div>
            
            <div class="app-scroll-content">
                <!-- 5-Day Study Streak Card -->
                <div class="streak-card">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <div style="display: flex; align-items: center; gap: 12px;">
                            <span style="font-size: 32px;">🔥</span>
                            <div>
                                <div style="font-size: 22px; font-weight: 800; color: #0F172A;">5-Day Study Streak</div>
                                <div style="font-size: 14px; color: #B45309; font-weight: 600;">Keep up your consistent daily habit!</div>
                            </div>
                        </div>
                        <span class="pill-tag pill-amber">ACTIVE</span>
                    </div>
                    
                    <div class="days-row">
                        <div class="day-pill done">M ✓</div>
                        <div class="day-pill done">T ✓</div>
                        <div class="day-pill done">W ✓</div>
                        <div class="day-pill done">T ✓</div>
                        <div class="day-pill done">F ✓</div>
                        <div class="day-pill pending">S</div>
                        <div class="day-pill pending">S</div>
                    </div>
                </div>
                
                <!-- Main Stats Row -->
                <div class="stats-row">
                    <div class="stat-card">
                        <div class="stat-value" style="color: #15803D;">94</div>
                        <div class="stat-label">Mastered</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value" style="color: #0284C7;">84%</div>
                        <div class="stat-label">Accuracy</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value" style="color: #7E22CE;">6</div>
                        <div class="stat-label">Mock Tests</div>
                    </div>
                </div>
                
                <!-- Question Bank Coverage Progress Bar -->
                <div class="custom-card">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                        <span style="font-size: 17px; font-weight: 800; color: #0F172A;">Question Bank Coverage</span>
                        <span style="font-size: 16px; font-weight: 800; color: #0284C7;">112 / 150 (75%)</span>
                    </div>
                    <div class="progress-bar-bg" style="height: 14px; margin-bottom: 12px;">
                        <div style="display: flex; height: 100%;">
                            <div style="width: 63%; background: #15803D;"></div>
                            <div style="width: 12%; background: #D97706;"></div>
                            <div style="width: 25%; background: #E2E8F0;"></div>
                        </div>
                    </div>
                    <div style="display: flex; justify-content: space-between; font-size: 13px; color: #64748B;">
                        <span><strong style="color: #15803D;">● 94</strong> Mastered</span>
                        <span><strong style="color: #D97706;">● 18</strong> Needs Review</span>
                        <span><strong style="color: #94A3B8;">● 38</strong> Unseen</span>
                    </div>
                </div>
                
                <!-- Category Performance Bars -->
                <div class="custom-card">
                    <div style="font-size: 18px; font-weight: 800; color: #0F172A; margin-bottom: 14px;">Category Performance</div>
                    
                    <div class="cat-bar-item">
                        <div style="display: flex; justify-content: space-between; font-size: 14px; color: #475569;">
                            <span>Traffic Rules & Regulations</span>
                            <span style="font-weight: 800; color: #15803D;">88%</span>
                        </div>
                        <div class="progress-bar-bg"><div class="progress-bar-fill" style="width: 88%; background: #15803D;"></div></div>
                    </div>
                    
                    <div class="cat-bar-item">
                        <div style="display: flex; justify-content: space-between; font-size: 14px; color: #475569;">
                            <span>Road Signs & Pavement Markings</span>
                            <span style="font-weight: 800; color: #15803D;">92%</span>
                        </div>
                        <div class="progress-bar-bg"><div class="progress-bar-fill" style="width: 92%; background: #15803D;"></div></div>
                    </div>
                    
                    <div class="cat-bar-item">
                        <div style="display: flex; justify-content: space-between; font-size: 14px; color: #475569;">
                            <span>Defensive Driving & Emergencies</span>
                            <span style="font-weight: 800; color: #15803D;">82%</span>
                        </div>
                        <div class="progress-bar-bg"><div class="progress-bar-fill" style="width: 82%; background: #15803D;"></div></div>
                    </div>
                    
                    <div class="cat-bar-item" style="margin-bottom: 0;">
                        <div style="display: flex; justify-content: space-between; font-size: 14px; color: #475569;">
                            <span>Vehicle Safety & Inspection</span>
                            <span style="font-weight: 800; color: #D97706;">76%</span>
                        </div>
                        <div class="progress-bar-bg"><div class="progress-bar-fill" style="width: 76%; background: #D97706;"></div></div>
                    </div>
                </div>

                <!-- Performance by Difficulty (from progress_screen.dart) -->
                <div class="custom-card">
                    <div style="font-size: 17px; font-weight: 800; color: #0F172A; margin-bottom: 12px;">Performance by Question Difficulty</div>
                    <div style="display: flex; justify-content: space-between; text-align: center;">
                        <div style="flex: 1; border-right: 1.5px solid #E2E8F0; padding: 4px;">
                            <div style="font-size: 24px; font-weight: 900; color: #15803D;">92%</div>
                            <div style="font-size: 13px; color: #64748B; margin-top: 2px;">Easy (55/60)</div>
                        </div>
                        <div style="flex: 1; border-right: 1.5px solid #E2E8F0; padding: 4px;">
                            <div style="font-size: 24px; font-weight: 900; color: #0284C7;">82%</div>
                            <div style="font-size: 13px; color: #64748B; margin-top: 2px;">Medium (41/50)</div>
                        </div>
                        <div style="flex: 1; padding: 4px;">
                            <div style="font-size: 24px; font-weight: 900; color: #D97706;">72%</div>
                            <div style="font-size: 13px; color: #64748B; margin-top: 2px;">Hard (29/40)</div>
                        </div>
                    </div>
                </div>

                <!-- Mock Exam Improvement Trend from App (Fixed overlap) -->
                <div class="custom-card">
                    <div style="font-size: 17px; font-weight: 800; color: #0F172A; margin-bottom: 22px; display: flex; justify-content: space-between; align-items: center;">
                        <span>Mock Exam Trend</span>
                        <span style="color: #15803D; font-size: 14px; font-weight: 800; background: #DCFCE7; padding: 4px 10px; border-radius: 6px;">+14.7% Improvement</span>
                    </div>
                    <div style="display: flex; justify-content: space-between; align-items: flex-end; height: 110px; padding: 0 28px;">
                        <div style="display: flex; flex-direction: column; align-items: center; gap: 8px;">
                            <span style="font-size: 14px; color: #64748B;">72%</span>
                            <div style="width: 64px; height: 48px; background: #BAE6FD; border-radius: 8px;"></div>
                            <span style="font-size: 12px; color: #94A3B8; font-weight: 600;">Exam 1</span>
                        </div>
                        <div style="display: flex; flex-direction: column; align-items: center; gap: 8px;">
                            <span style="font-size: 14px; color: #64748B;">78%</span>
                            <div style="width: 64px; height: 62px; background: #7DD3FC; border-radius: 8px;"></div>
                            <span style="font-size: 12px; color: #94A3B8; font-weight: 600;">Exam 2</span>
                        </div>
                        <div style="display: flex; flex-direction: column; align-items: center; gap: 8px;">
                            <span style="font-size: 15px; font-weight: 900; color: #15803D;">86.7%</span>
                            <div style="width: 64px; height: 80px; background: #22C55E; border-radius: 8px; box-shadow: 0 4px 12px rgba(34, 197, 94, 0.3);"></div>
                            <span style="font-size: 12px; font-weight: 800; color: #15803D;">Exam 3 (Passed)</span>
                        </div>
                    </div>
                </div>

                <!-- Latest Attempt Card -->
                <div class="custom-card" style="background: #F0FDF4; border-color: #BBF7D0; padding: 18px 22px;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">
                        <span class="pill-tag pill-green" style="font-size: 12px; padding: 4px 10px;">RECENT MOCK TEST #3</span>
                        <span style="font-size: 13px; color: #64748B;">Today • 32 mins</span>
                    </div>
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <div style="font-size: 20px; font-weight: 800; color: #0F172A;">Score: 52 / 60 <span style="color: #15803D;">(86.7%)</span></div>
                        <span style="font-size: 13px; font-weight: 700; color: #0284C7;">Review Test →</span>
                    </div>
                </div>
                
                <!-- Action Cards: Target Weak Spots -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 14px;">
                    <div class="custom-card" style="padding: 18px 20px; display: flex; align-items: center; justify-content: space-between;">
                        <div>
                            <div style="font-size: 16px; font-weight: 800; color: #0F172A;">Wrong Answers</div>
                            <div style="font-size: 13px; color: #DC2626;">18 items to master</div>
                        </div>
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="#DC2626"><path d="M8.59 16.59L13.17 12 8.59 7.41 10 6l6 6-6 6-1.41-1.41z"/></svg>
                    </div>
                    <div class="custom-card" style="padding: 18px 20px; display: flex; align-items: center; justify-content: space-between;">
                        <div>
                            <div style="font-size: 16px; font-weight: 800; color: #0F172A;">Difficult Items</div>
                            <div style="font-size: 13px; color: #D97706;">12 bookmarked</div>
                        </div>
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="#D97706"><path d="M8.59 16.59L13.17 12 8.59 7.41 10 6l6 6-6 6-1.41-1.41z"/></svg>
                    </div>
                </div>

                <!-- Overall Readiness Certification Badge -->
                <div class="custom-card" style="background: #F0FDF4; border-color: #86EFAC; padding: 16px 22px; display: flex; align-items: center; justify-content: space-between;">
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <span style="font-size: 26px;">🏆</span>
                        <div>
                            <div style="font-size: 16px; font-weight: 800; color: #15803D;">LTO Exam Readiness: HIGH</div>
                            <div style="font-size: 13px; color: #475569;">Based on 6 completed mock exams and 112 practice items.</div>
                        </div>
                    </div>
                    <span class="pill-tag pill-green" style="font-size: 12px; padding: 4px 10px;">READY</span>
                </div>
            </div>
            
            {build_bottom_nav(4)}
        </div>
    </div>
</body>
</html>"""
    out_file = os.path.join(OUT_DIR, 'screenshot_5_progress.png')
    render_html_to_png(content, out_file)


if __name__ == '__main__':
    print("Building all 5 Google Play Store Screenshots in LIGHT THEME...")
    build_screenshot_1()
    build_screenshot_2()
    build_screenshot_3()
    build_screenshot_4()
    build_screenshot_5()
    print("All screenshots generated successfully.")
