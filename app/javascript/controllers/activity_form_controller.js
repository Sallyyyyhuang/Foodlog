import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["typeSelect", "durationField", "stepsField"]

  connect() {
    this.toggleSteps()
  }

  toggleSteps() {
    const isWalking = this.typeSelectTarget.value === "walking"
    this.stepsFieldTarget.classList.toggle("is-hidden", !isWalking)
    this.durationFieldTarget.classList.toggle("is-hidden", isWalking)
  }
}
