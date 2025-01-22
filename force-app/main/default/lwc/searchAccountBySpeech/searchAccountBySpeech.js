import { LightningElement, track } from 'lwc';
import searchAccountByName from '@salesforce/apex/AccountSearchController.searchAccountByName';

export default class SearchAccountBySpeech extends LightningElement {
    @track accountList = [];
    @track errorMessage = '';
    @track isListening = false;
    @track isSpeaking = false;

    handleSearch() {
        const recognition = new (window.SpeechRecognition || window.webkitSpeechRecognition)();
        recognition.lang = 'en-US';
        recognition.interimResults = false;
        recognition.maxAlternatives = 1;

        this.isListening = true;

        recognition.start();

        recognition.onresult = (event) => {
            const accountName = event.results[0][0].transcript;
            console.log(`Recognized speech: ${accountName}`);
            this.searchAccount(accountName);
        };

        recognition.onspeechend = () => {
            recognition.stop();
            this.isListening = false;
        };

        recognition.onerror = (event) => {
            console.error(`Speech recognition error: ${event.error}`);
            this.errorMessage = `Speech recognition error: ${event.error}`;
            this.isListening = false;
        };
    }

    searchAccount(accountName) {
        searchAccountByName({ name: accountName })
            .then((result) => {
                this.accountList = result;
                this.errorMessage = '';

                // Convert account names to audio
                const names = result.map((account) => account.Name).join(', ');
                if (names) {
                    this.speak(`Found accounts: ${names}`);
                } else {
                    this.speak('No accounts found');
                }
            })
            .catch((error) => {
                this.errorMessage = 'Error searching for account';
                console.error(error);
            });
    }

    speak(text) {
        const utterance = new SpeechSynthesisUtterance(text);
        utterance.onstart = () => {
            this.isSpeaking = true;
        };
        utterance.onend = () => {
            this.isSpeaking = false;
        };

        speechSynthesis.speak(utterance);
    }
}