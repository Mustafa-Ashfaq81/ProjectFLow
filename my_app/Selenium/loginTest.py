from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch()
    page = browser.new_page()
    page.goto("http://localhost:54394")

    # Fill in the email and password fields
    page.fill('input:nth-child(1)', 'test@example.com')
    page.fill('input:nth-child(2)', 'password123')

    # Click the login button
    page.click('button')

    browser.close()
