import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["banner"]

  connect() {
    console.log("Hello!")
  }

  shrinkBanner() {
    // event.preventDefault()
    this.bannerTarget.classList.add("shrink")
  }
}
