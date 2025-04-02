// app/javascript/controllers/fin_chat_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["messageContainer", "messageInput"]

    connect() {
        this.scrollToBottom()
    }

    scrollToBottom() {
        const container = this.messageContainerTarget
        container.scrollTop = container.scrollHeight
    }

    clearInput() {
        this.messageInputTarget.value = ""
    }

    messageSent() {
        this.clearInput()
        setTimeout(() => {
            this.scrollToBottom()
        }, 100)
    }
}