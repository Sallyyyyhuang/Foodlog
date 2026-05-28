import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["time", "date"]

  connect() {
    this.update()
    this.timer = setInterval(() => this.update(), 1000)
  }

  disconnect() {
    clearInterval(this.timer)
  }

  update() {
    const now = new Date()
    this.timeTarget.textContent = now.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit", second: "2-digit" })
    this.dateTarget.textContent = now.toLocaleDateString([], { weekday: "long", month: "long", day: "numeric" })
  }
}
