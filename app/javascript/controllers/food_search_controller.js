import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["query", "results"]

  search() {
    const query = this.queryTarget.value.trim()
    if (query.length < 2) {
      this.clearResults()
      return
    }

    clearTimeout(this._debounce)
    this._debounce = setTimeout(async () => {
      const res = await fetch(`/food_search?query=${encodeURIComponent(query)}`)
      const foods = await res.json()
      this.showResults(foods)
    }, 300)
  }

  showResults(foods) {
    const container = this.resultsTarget
    container.innerHTML = ""

    if (foods.length === 0) {
      container.classList.add("is-hidden")
      return
    }

    foods.forEach(food => {
      const item = document.createElement("a")
      item.className = "panel-block"
      item.style.cursor = "pointer"
      item.textContent = `${food.name} — ${food.calories} kcal`
      item.addEventListener("click", () => this.fillForm(food))
      container.appendChild(item)
    })

    container.classList.remove("is-hidden")
  }

  fillForm(food) {
    const form = this.element.closest("form")
    if (!form) return

    const set = (attr, val) => {
      const field = form.querySelector(`[data-food-search-field="${attr}"]`)
      if (field) field.value = val
    }

    set("meal_type", food.name)
    set("calories", food.calories)
    set("proteins", food.proteins)
    set("carbohydrates", food.carbohydrates)
    set("fats", food.fats)

    this.queryTarget.value = food.name
    this.clearResults()
  }

  clearResults() {
    this.resultsTarget.innerHTML = ""
    this.resultsTarget.classList.add("is-hidden")
  }
}
